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

variable "github_token" {}
variable "github_webhook_secret" {}

# create gce from modules gce
module "gcompute-engine" {
  source            = "../../modules/compute/gcompute-engine"
  region            = "asia-southeast2"
  unit              = "ols"
  env               = "dev"
  code              = "gce"
  feature           = ["bastion"]
  machine_type      = "e2-micro"
  disk_size         = 10
  disk_type         = "pd-standard"
  network_self_link = data.terraform_remote_state.vpc_ols_network.outputs.vpc_self_link
  subnet_self_link  = data.terraform_remote_state.vpc_ols_network.outputs.subnet_self_link
  tags              = ["bastion"]
  image             = "debian-cloud/debian-11"
  firewall_rules = {
    "ssh" = {
      protocol = "tcp"
      ports    = ["22"]
    }
  }
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
  cluster_name  = data.terraform_remote_state.gkubernetes_engine_ols.outputs.cluster_name
}
