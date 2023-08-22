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

# service account arguments

variable "create_service_account" {
  type        = bool
  description = "create service account"
  default     = false
}

variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "service_account_role" {
  type        = string
  description = "GCP service account role"
}

variable "kubernetes_cluster_role_rules" {
  type = object({
    api_groups : list(string),
    resources : list(string),
    verbs : list(string)
  })
  description = "kubernetes cluster role rules"
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

variable "helm_sets" {
  type        = list(object({ name : string, value : any }))
  description = "list of helm set"
  default     = []
}
