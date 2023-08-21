#Naming Standard
variable "region" {
  type        = string
  description = "The GCP region where resources will be created."
}

variable "unit" {
  type        = string
  description = "Business unit code."
}

variable "env" {
  type        = string
  description = "Stage environment where the infrastructure will be deployed."
}

variable "code" {
  type        = string
  description = "Service domain code."
}

variable "feature" {
  type        = list(string)
  description = "Feature names"
}

# keyring arguments
variable "location" {
  type        = string
  description = "The location of the keyring"
}

# cryptokey arguments
variable "rotation_period" {
  type        = string
  description = "The rotation period of the cryptokey"
}

variable "destroy_scheduled_duration" {
  type        = string
  description = "The destroy scheduled duration of the cryptokey"
}

variable "purpose" {
  type        = string
  description = "The purpose of the cryptokey"
}

variable "version_template" {
  type        = map(string)
  description = "The version template of the cryptokey"
}

# service account arguments
variable "cryptokey_role" {
  type        = string
  description = "The role of the service account"
}