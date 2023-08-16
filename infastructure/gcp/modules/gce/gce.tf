# create ssh private key
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.tls.private_key_pem
  filename = "private_key.pem"
  file_permission = "0400"
}

# Bastion host
resource "google_compute_instance" "bastion" {
  name         = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  machine_type = var.gce_machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      type = var.gce_disk_type
      size = var.gce_disk_size
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

  tags = var.gce_tags
  provisioner "local-exec" {
    command = "sleep 30 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.network_interface.0.access_config.0.nat_ip},' -u debian --private-key=private_key.pem '${path.module}'/bastion-playbook.yml -e kubeconfig='${var.kubeconfig}'"
  }
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