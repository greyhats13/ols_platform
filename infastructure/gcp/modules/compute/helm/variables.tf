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

# helm arguments
variable "release_name" {
  type        = string
  description = "helm release name"
  default     = "helm"
}

variable "repository" {
  type        = string
  description = "helm repository"
}

variable "chart" {
  type        = string
  description = "helm chart"
}

variable "values" {
  type        = list(string)
  description = "helm values"
  default     = []
}

variable "namespace" {
  type        = string
  description = "helm namespace"
  default     = "default"
}

variable "create_namespace" {
  type        = bool
  description = "helm create namespace"
  default     = false
}

variable "helm_sets" {
  type        = list(object({ name : string, value : any }))
  description = "list of helm set"
  default = []
}