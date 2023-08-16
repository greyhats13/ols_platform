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

# subnet arguments
variable "subnetwork_ip_cidr_range" {
  type        = string
  description = "the subnetwork ip cidr range to use"
}

variable "pods_range_name" {
  type = string
  description = "the pods range name"
}

variable "services_range_name" {
  type = string
  description = "the services range name"
}

variable "pods_ip_cidr_range" {
  type        = string
  description = "IP CIDR range for GKE pods"
}

variable "services_ip_cidr_range" {
  type        = string
  description = "IP CIDR range for GKE services"
}