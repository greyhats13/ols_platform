

#Naming Standard
variable "region" {
  type        = string
  description = "GCP region"
}

variable "unit" {
  type        = string
  description = "business unit code"
}

variable "env" {
  type        = string
  description = "stage environment where the infrastructure will be deployed"
}

variable "code" {
  type        = string
  description = "service domain code to use"
}

variable "feature" {
  type        = list(string)
  description = "the name of AWS services feature"
}

# gce arguments
variable "gce_machine_type" {
  type        = string
  description = "the machine type to use"
}

variable "gce_disk_size" {
  type        = number
  description = "the disk size to use"
}

variable "gce_disk_type" {
  type        = string
  description = "the disk type to use"
}

variable "gce_tags" {
  type        = list(string)
  description = "the tags to use"
}
  
variable "gce_image" {
  type        = string
  description = "the image to use"
}

variable "network_self_link" {
  type        = string
  description = "the netwnetwork_self_link to use"
}

variable "subnet_self_link" {
  type        = string
  description = "the subnet_slef_link to use"
}

# gcf arguments
variable "gcf_protocol" {
  type        = string
  description = "the gcf firewall protocol to use"
}

variable "gcf_ports" {
  type        = list(string)
  description = "the gcf firewall ports to use"
}

variable "gcf_source_ranges" {
  type        = list(string)
  description = "the gcf firewall source ranges to use"
}

variable "gcf_target_tags" {
  type        = list(string)
  description = "the gcf firewall target tags to use"
}