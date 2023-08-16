# create vpc from modules network
module "vpc" {
  source                   = "../modules/vpc"
  region                   = "asia-southeast2"
  unit                     = "ols"
  env                      = "dev"
  code                     = "network"
  feature                  = ["vpc", "subnet"]
  subnetwork_ip_cidr_range = "10.0.0.0/16"
  pods_range_name          = "pods-range"
  pods_ip_cidr_range       = "172.16.0.0/16"
  services_range_name      = "services-range"
  services_ip_cidr_range   = "172.17.0.0/16"
}

# create gke from modules gke
module "gke" {
  source                            = "../modules/gke"
  region                            = "asia-southeast2"
  unit                              = "ols"
  env                               = "dev"
  code                              = "gke"
  feature                           = ["cluster", "np"]
  network_self_link                 = module.vpc.vpc_self_link
  subnet_self_link                  = module.vpc.subnet_self_link
  gke_pods_secondary_range_name     = "pods-range"
  gke_services_secondary_range_name = "services-range"
  gke_remove_default_node_pool      = true
  gke_initial_node_count            = 1
  gke_issue_client_certificate      = true
  gke_oauth_scopes                  = ["https://www.googleapis.com/auth/cloud-platform"]
  ondemand_node_count               = 1
  ondemand_machine_type             = "e2-medium"
  ondemand_disk_size_gb             = 20
  ondemand_disk_type                = "pd-standard"
  ondemand_tags                     = ["ondemand"]
  ondemand_oauth_scopes             = ["https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"]
  preemptible_machine_type          = "e2-medium"
  preemptible_disk_size_gb          = 20
  preemptible_disk_type             = "pd-standard"
  preemptible_tags                  = ["preemptible"]
  preemptible_oauth_scopes          = ["https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"]
  preemptible_min_node_count        = 0
  preemptible_max_node_count        = 20
}


# # create gce from modules gce
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
  kubeconfig        = module.gke.kubeconfig
}
