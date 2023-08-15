# create vpc from modules network
module "vpc" {
  source                   = "../modules/vpc"
  region                   = "asia-southeast2"
  unit                     = "ols"
  env                      = "dev"
  code                     = "network"
  feature                  = ["vpc", "subnet"]
  subnetwork_ip_cidr_range = "10.0.0.0/16"
}

# create gce from modules gce
module "bastion" {
  source            = "../modules/gce"
  region            = "asia-southeast2"
  unit              = "ols"
  env               = "dev"
  code              = "gce"
  feature           = ["bastion"]
  gce_machine_type  = "e2-micro"
  gce_disk_size     = 10
  gce_disk_type     = "pd-standard"
  network_self_link = module.vpc.vpc_self_link
  subnet_self_link  = module.vpc.subnet_self_link
  gce_tags          = ["bastion"]
  gce_image         = "debian-cloud/debian-11"
  gcf_protocol      = "tcp"
  gcf_ports         = ["22"]
  gcf_source_ranges = ["0.0.0.0/0"]
  gcf_target_tags   = ["bastion"]
}
