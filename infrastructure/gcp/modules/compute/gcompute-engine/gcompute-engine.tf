# create ssh private key
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# create private key file
resource "local_file" "private_key" {
  content              = tls_private_key.tls.private_key_pem
  filename             = "id_rsa.pem"
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
    dynamic "access_config" {
      for_each = var.is_public ? [lookup(var.access_config, var.env)] : []
      content {
        nat_ip                 = access_config.value.nat_ip == "" ? null : access_config.value.nat_ip
        public_ptr_domain_name = access_config.value.public_ptr_domain_name == "" ? null : access_config.value.public_ptr_domain_name
        network_tier           = access_config.value.network_tier == "" ? null : access_config.value.network_tier
      }
    }
  }

  metadata = {
    ssh-keys = "${var.username}:${tls_private_key.tls.public_key_openssh}"
  }

  service_account {
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }
  tags = var.tags
}

# Create dns record for gcompute engine instance
resource "google_dns_record_set" "record" {
  count = var.create_dns_record ? 1 : 0
  name  = "${var.feature[0]}.${var.dns_config.dns_name}"
  type  = var.dns_config.record_type
  ttl   = var.dns_config.ttl

  managed_zone = var.dns_config.dns_zone_name

  rrdatas = [google_compute_instance.instance.network_interface.0.access_config.0.nat_ip]
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

# Create ansible vars file
resource "local_file" "ansible_vars" {
  count    = var.run_ansible ? 1 : 0
  content  = jsonencode(var.ansible_vars)
  filename = "ansible_vars.json"
}

# Run ansible playbook
resource "null_resource" "ansible_playbook" {
  count = var.run_ansible ? 1 : 0
  provisioner "local-exec" {
    command = "sleep 30 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${google_compute_instance.instance.network_interface.0.access_config.0.nat_ip}, -u ${var.username} --private-key=id_rsa.pem playbook.yml  --extra-vars '@ansible_vars.json'"
  }

  triggers = {
    playbook_checksum = filesha256("playbook.yml")
  }

  depends_on = [
    local_file.ansible_vars,
    google_compute_instance.instance,
    google_dns_record_set.record
  ]
}
