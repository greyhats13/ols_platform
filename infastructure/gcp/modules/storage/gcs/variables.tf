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
  type        = string
  description = "the name of AWS services feature"
}

# subnet arguments
variable "bucket_name" {
  type        = string
  description = "the bucket name to use"
}

variable "force_destroy" {
  type        = bool
  description = "set to true to destroy all objects in the bucket when destroying bucket"
}

variable "public_access_prevention" {
  type        = string
  description = "set to true to prevent public access to the bucket"
}