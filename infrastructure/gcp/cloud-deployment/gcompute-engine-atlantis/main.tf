# Terraform State Storage
terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcompute-engine/ols-dev-gcompute-engine-atlantis"
  }
}

# Terraform state data vpc network
data "terraform_remote_state" "vpc_ols_network" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "vpc/ols-dev-vpc-network"
  }
}

# Terraform state data gkubernetes engine
data "terraform_remote_state" "gkubernetes_engine_ols" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gkubernetes-engine/ols-dev-gkubernetes-engine-ols"
  }
}

# Terraform state data gcloud dns
data "terraform_remote_state" "gcloud_dns_ols" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcloud-dns/ols-dev-gcloud-dns-blast"
  }
}

# Terraform state data kms cryptokey
data "terraform_remote_state" "kms_ols_cryptokey" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcloud-kms/ols-dev-gcloud-kms-ols"
  }
}

# Load encrypted github token and webhook secret from github.auto.tfvars
variable "github_token_ciphertext" {}
variable "github_webhook_secret_ciphertext" {}
variable "atlantis_password_ciphertext" {}

# Decrypt github token and webhook secret using kms cryptokey
data "google_kms_secret" "github_token" {
  crypto_key = data.terraform_remote_state.kms_ols_cryptokey.outputs.cryptokey_id
  ciphertext = var.github_token_ciphertext
}

data "google_kms_secret" "github_webhook_secret" {
  crypto_key = data.terraform_remote_state.kms_ols_cryptokey.outputs.cryptokey_id
  ciphertext = var.github_webhook_secret_ciphertext
}

data "google_kms_secret" "atlantis_password" {
  crypto_key = data.terraform_remote_state.kms_ols_cryptokey.outputs.cryptokey_id
  ciphertext = var.atlantis_password_ciphertext
}

# Get current project id
data "google_project" "current" {}

# create gce from modules gce
module "gcompute-engine" {
  source               = "../../modules/compute/gcompute-engine"
  region               = "asia-southeast2"
  unit                 = "ols"
  env                  = "dev"
  code                 = "gce"
  feature              = ["atlantis"]
  zone                 = "asia-southeast2-a"
  project_id           = data.google_project.current.project_id
  service_account_role = "roles/owner"
  username             = "debian" # linux or windows username
  machine_type         = "e2-medium"
  disk_size            = 20
  disk_type            = "pd-standard"
  network_self_link    = data.terraform_remote_state.vpc_ols_network.outputs.vpc_self_link
  subnet_self_link     = data.terraform_remote_state.vpc_ols_network.outputs.subnet_self_link
  is_public            = true
  access_config = {
    dev = {
      nat_ip                 = ""
      public_ptr_domain_name = ""
      network_tier           = "STANDARD"
    }
    stg = {
      nat_ip                 = ""
      public_ptr_domain_name = ""
      network_tier           = "PREMIUM"
    }
    prd = {
      nat_ip                 = ""
      public_ptr_domain_name = ""
      network_tier           = "PREMIUM"
    }
  }
  tags              = ["atlantis"]
  image             = "debian-cloud/debian-11"
  create_dns_record = true
  dns_config = {
    dns_name      = data.terraform_remote_state.gcloud_dns_ols.outputs.dns_name
    dns_zone_name = data.terraform_remote_state.gcloud_dns_ols.outputs.dns_zone_name
    record_type   = "A"
    ttl           = 300
  }
  run_ansible       = true
  ansible_tags      = ["initialization"]
  ansible_skip_tags = []
  ansible_vars = {
    project_id            = data.google_project.current.project_id
    cluster_name          = data.terraform_remote_state.gkubernetes_engine_ols.outputs.cluster_name
    region                = "asia-southeast2-a"
    github_token          = data.google_kms_secret.github_token.plaintext
    github_webhook_secret = data.google_kms_secret.github_webhook_secret.plaintext
    atlantis_password     = data.google_kms_secret.atlantis_password.plaintext
  }
  firewall_rules = {
    "ssh" = {
      protocol = "tcp"
      ports    = ["22"]
    }
    "http" = {
      protocol = "tcp"
      ports    = ["80"]
    }
    "atlantis" = {
      protocol = "tcp"
      ports    = ["4141"]
    }
    "https" = {
      protocol = "tcp"
      ports    = ["443"]
    }
  }
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["atlantis"]
}
