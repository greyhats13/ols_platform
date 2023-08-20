# create ssh private key
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# create private key file
resource "local_file" "private_key" {
  content              = tls_private_key.tls.private_key_pem
  filename             = "private_key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

locals {
  project_id = var.project_id
}

# create service account for gcompute engine
resource "google_service_account" "sa" {
  account_id   = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  display_name = "Service Account for ${var.unit}-${var.env}-${var.code}-${var.feature[0]} instance"
}

# resource "google_service_account_key" "sa_key" {
#   service_account_id = google_service_account.sa.name
#   public_key_type    = "TYPE_X509_PEM_FILE"
# }

# create gcompute engine service account IAM
resource "google_project_iam_member" "sa_iam" {
  project = local.project_id
  role    = var.service_account_role
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Create compute engine instance
resource "google_compute_instance" "instance" {
  name         = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      type  = var.disk_type
      size  = var.disk_size
      image = var.image
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

  tags = var.tags
  provisioner "local-exec" {
    # 30s after instance is created, run ansible playbook
    command = "sleep 30 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, -u ${var.username} --private-key=private_key.pem playbook.yml ${var.extra_args[var.env]}"
  }
}

# Firewall rule for gcompute engine instance
resource "google_compute_firewall" "firewall" {
  for_each = var.firewall_rules
  name     = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}-allow-${each.key}"
  network  = var.network_self_link

  dynamic "allow" {
    for_each = var.firewall_rules
    content {
      protocol = each.value.protocol
      ports    = each.value.ports
    }
  }
  priority      = var.priority
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}
