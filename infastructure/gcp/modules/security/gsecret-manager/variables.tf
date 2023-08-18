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

# gsm arguments

variable "gsm_secret_id" {
  type = string
  description = "the name of the secret"
}

variable "gsm_labels" {
  type = map(string)
  description = "the labels of the secret"
  default = {}
}

variable "gsm_annotations" {
  type = map(string)
  description = "the annotations of the secret"
  default = {}
}

variable "gsm_secret_data" {}
