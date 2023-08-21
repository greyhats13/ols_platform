# Terraform State Storage
terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcompute-engine/ols-dev-gcompute-engine-bastion"
  }
}

data "terraform_remote_state" "vpc_ols_network" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "vpc/ols-dev-vpc-network"
  }
}

data "terraform_remote_state" "gkubernetes_engine_ols" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gkubernetes-engine/ols-dev-gkubernetes-engine-ols"
  }
}

variable "github_token_ciphertext" {}
variable "github_webhook_secret_ciphertext" {}

data "terraform_remote_state" "kms_ols_cryptokey" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcloud-kms/ols-dev-gcloud-kms-ols"
  }
}

data "google_kms_secret" "github_token" {
  crypto_key = data.terraform_remote_state.kms_ols_cryptokey.outputs.cryptokey_id
  ciphertext = var.github_token_ciphertext
}

data "google_kms_secret" "github_webhook_secret" {
  crypto_key = data.terraform_remote_state.kms_ols_cryptokey.outputs.cryptokey_id
  ciphertext = var.github_webhook_secret_ciphertext
}


data "google_project" "current" {}

# create gce from modules gce
module "gcompute-engine" {
  source                = "../../modules/compute/gcompute-engine"
  region                = "asia-southeast2"
  unit                  = "ols"
  env                   = "dev"
  code                  = "gce"
  feature               = ["atlantis"]
  zone                  = "asia-southeast2-a"
  project_id            = data.google_project.current.project_id
  service_account_role  = "roles/owner"
  username              = "debian" # linux or windows username
  machine_type          = "e2-medium"
  disk_size             = 20
  disk_type             = "pd-standard"
  network_self_link     = data.terraform_remote_state.vpc_ols_network.outputs.vpc_self_link
  subnet_self_link      = data.terraform_remote_state.vpc_ols_network.outputs.subnet_self_link
  tags                  = ["atlantis"]
  image                 = "debian-cloud/debian-11"
  extra_args            = {
    dev = "-e project_id='${data.google_project.current.project_id}' -e cluster_name='${data.terraform_remote_state.gkubernetes_engine_ols.outputs.cluster_name}' -e region='asia-southeast2-a' -e github_token='${data.google_kms_secret.github_token.plaintext}' -e github_webhook_secret='${data.google_kms_secret.github_webhook_secret.plaintext}'"
    stg = "-e project_id='${data.google_project.current.project_id}' -e cluster_name='${data.terraform_remote_state.gkubernetes_engine_ols.outputs.cluster_name}' -e region='asia-southeast2' -e github_token='${data.google_kms_secret.github_token.plaintext}' -e github_webhook_secret='${data.google_kms_secret.github_webhook_secret.plaintext}'"
    prd = "-e project_id='${data.google_project.current.project_id}' -e cluster_name='${data.terraform_remote_state.gkubernetes_engine_ols.outputs.cluster_name}' -e region='asia-southeast2' -e github_token='${data.google_kms_secret.github_token.plaintext}' -e github_webhook_secret='${data.google_kms_secret.github_webhook_secret.plaintext}'"
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

data "terraform_remote_state" "gcloud_dns_ols" {
  backend = "gcs"

  config = {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "gcloud-dns/ols-dev-gcloud-dns-blast"
  }
}

module "gcloud-dns-record" {
  source = "../../modules/network/gcloud-dns-record"

  dns_name      = data.terraform_remote_state.gcloud_dns_ols.outputs.dns_name 
  dns_zone_name = data.terraform_remote_state.gcloud_dns_ols.outputs.dns_zone_name
  subdomain     = "atlantis"
  record_type   = "A"
  ttl           = 300
  rrdatas       = [module.gcompute-engine.public_ip]
}
