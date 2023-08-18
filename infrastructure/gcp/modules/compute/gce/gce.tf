# create ssh private key
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# create private key file
resource "local_file" "private_key" {
  content         = tls_private_key.tls.private_key_pem
  filename        = "private_key.pem"
  file_permission = "0400"
}

data "google_project" "current" {}

locals {
  project_id = data.google_project.current.project_id
}

# create bastion service account
resource "google_service_account" "sa" {
  account_id   = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}-bastion"
  display_name = "Service Account for Bastion Host"
}

resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# create bastion gke admin role
resource "google_project_iam_member" "bastion_gke_admin" {
  project = local.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Bastion host
resource "google_compute_instance" "bastion" {
  name         = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  machine_type = var.gce_machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      type  = var.gce_disk_type
      size  = var.gce_disk_size
      image = var.gce_image
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {
    }
  }

  metadata = {
    ssh-keys = "debian:${tls_private_key.tls.public_key_openssh}"
  }

  service_account {
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }

  tags = var.gce_tags
  # provisioner "local-exec" {
  #   #command for ansible playbook
  #   command = "sleep 30 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.network_interface.0.access_config.0.nat_ip},' -u debian --private-key=private_key.pem '${path.module}'/playbook.yml -e service_account_key='${google_service_account_key.sa_key.private_key}' -e project_id='${local.project_id}'  -e cluster_name='${var.cluster_name}' -e region='${var.region}'"
  # }
}

# Firewall rule buat allow SSH ke bastion host
resource "google_compute_firewall" "bastion_ssh" {
  name    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}-firewall"
  network = var.network_self_link

  allow {
    protocol = var.gcf_protocol
    ports    = var.gcf_ports
  }

  source_ranges = var.gcf_source_ranges
  target_tags   = var.gcf_target_tags
}
