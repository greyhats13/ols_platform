# Berikut adalah path module terraform gue gcp/modules/network/ beserta isinya
# vpc.tf 
# ```terraform
# # Create a VPC
# resource "google_compute_network" "vpc" {
#   name                    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
#   auto_create_subnetworks = false
# }

# # Create a subnet
# resource "google_compute_subnetwork" "subnet" {
#   name          = "${var.unit}-${var.env}-${var.code}-${var.feature[1]}-jakarta"
#   ip_cidr_range = var.subnetwork_ip_cidr_range
#   region        = var.region
#   network       = google_compute_network.vpc.self_link
#   depends_on    = [google_compute_network.vpc]
# }
# ```
# variables.tf
# ```terraform
# #Naming Standard
# variable "region" {
#   type        = string
#   description = "GCP region"
# }

# variable "unit" {
#   type        = string
#   description = "business unit code"
# }

# variable "env" {
#   type        = string
#   description = "stage environment where the infrastructure will be deployed"
# }

# variable "code" {
#   type        = string
#   description = "service domain code to use"
# }

# variable "feature" {
#   type        = list(string)
#   description = "the name of AWS services feature"
# }

# # subnet arguments
# variable "subnetwork_ip_cidr_range" {
#   type        = string
#   description = "the subnetwork ip cidr range to use"
# }
# ```

# outputs.tf:
# ```terraform
# # VPC output

# output "vpc_id" {
#   value = google_compute_network.vpc.id
# }

# output "vpc_self_link" {
#   value = google_compute_network.vpc.self_link
# }

# output "vpc_gateway_ipv4" {
#   value = google_compute_network.vpc.gateway_ipv4
# }


# # Subnetwork output
# output "subnet_network" {
#   value = google_compute_subnetwork.subnet.network
# }

# output "subnet_self_link" {
#   value = google_compute_subnetwork.subnet.self_link
# }

# output "subnet_ip_cidr_range" {
#   value = google_compute_subnetwork.subnet.ip_cidr_range
# }
# ```

# Berikut adalah path module terraform gue gcp/modules/gce/ beserta isinya:
# gce.tf
# ```terraform
# # Bastion host
# resource "google_compute_instance" "bastion" {
#   name         = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
#   machine_type = var.gce_machine_type
#   zone         = "${var.region}-a"

#   boot_disk {
#     initialize_params {
#       type = var.gce_disk_type
#       size = var.gce_disk_size
#       image = var.gce_image
#     }
#   }

#   network_interface {
#     subnetwork = var.subnet_self_link
#     access_config {
#     }
#   }

#   tags = var.gce_tags
# }

# # Firewall rule buat allow SSH ke bastion host
# resource "google_compute_firewall" "bastion_ssh" {
#   name    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}-firewall"
#   network = var.network_self_link

#   allow {
#     protocol = var.gcf_protocol
#     ports    = var.gcf_ports
#   }

#   source_ranges = var.gcf_source_ranges
#   target_tags   = var.gcf_target_tags
# }
# ```

# variables.tf
# ```terraform


# #Naming Standard
# variable "region" {
#   type        = string
#   description = "GCP region"
# }

# variable "unit" {
#   type        = string
#   description = "business unit code"
# }

# variable "env" {
#   type        = string
#   description = "stage environment where the infrastructure will be deployed"
# }

# variable "code" {
#   type        = string
#   description = "service domain code to use"
# }

# variable "feature" {
#   type        = list(string)
#   description = "the name of AWS services feature"
# }

# # gce arguments
# variable "gce_machine_type" {
#   type        = string
#   description = "the machine type to use"
# }

# variable "gce_disk_size" {
#   type        = number
#   description = "the disk size to use"
# }

# variable "gce_disk_type" {
#   type        = string
#   description = "the disk type to use"
# }

# variable "gce_tags" {
#   type        = list(string)
#   description = "the tags to use"
# }
  
# variable "gce_image" {
#   type        = string
#   description = "the image to use"
# }

# variable "network_self_link" {
#   type        = string
#   description = "the netwnetwork_self_link to use"
# }

# variable "subnet_self_link" {
#   type        = string
#   description = "the subnet_slef_link to use"
# }

# # gcf arguments
# variable "gcf_protocol" {
#   type        = string
#   description = "the gcf firewall protocol to use"
# }

# variable "gcf_ports" {
#   type        = list(string)
#   description = "the gcf firewall ports to use"
# }

# variable "gcf_source_ranges" {
#   type        = list(string)
#   description = "the gcf firewall source ranges to use"
# }

# variable "gcf_target_tags" {
#   type        = list(string)
#   description = "the gcf firewall target tags to use"
# }
# ```

# ```terraform
# # create vpc from modules network
# module "vpc" {
#   source                   = "../modules/vpc"
#   region                   = "asia-southeast2"
#   unit                     = "ols"
#   env                      = "dev"
#   code                     = "network"
#   feature                  = ["vpc", "subnet"]
#   subnetwork_ip_cidr_range = "10.0.0.0/16"
# }

# # create gce from modules gce
# module "bastion" {
#   source            = "../modules/gce"
#   region            = "asia-southeast2"
#   unit              = "ols"
#   env               = "dev"
#   code              = "gce"
#   feature           = ["bastion"]
#   gce_machine_type  = "e2-micro"
#   gce_disk_size     = 10
#   gce_disk_type     = "pd-standard"
#   network_self_link = module.vpc.vpc_self_link
#   subnet_self_link  = module.vpc.subnet_self_link
#   gce_tags          = ["bastion"]
#   gce_image         = "debian-cloud/debian-11"
#   gcf_protocol      = "tcp"
#   gcf_ports         = ["22"]
#   gcf_source_ranges = ["0.0.0.0/0"]
#   gcf_target_tags   = ["bastion"]
# }
# ```