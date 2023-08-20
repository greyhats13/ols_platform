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

# gke arguments
variable "issue_client_certificate" {
  type        = bool
  description = "issue client certificate"
}

variable "vpc_self_link" {
  type        = string
  description = "the vpc self link"
}

variable "subnet_self_link" {
  type        = string
  description = "the subnet self link"
}


variable "private_cluster_config" {
  type = map(object({
    enable_private_endpoint = bool
    enable_private_nodes    = bool
    master_ipv4_cidr_block  = string
  }))
  description = "private cluster config"
}

variable "enable_autopilot" {
  type        = bool
  description = "enable autopilot"
}

variable "cluster_autoscaling" {
  type = object({
    enabled = bool
    resource_limits = map(object({
      minimum       = number
      maximum       = number
    }))
  })
  description = "the cluster autoscaling"
}

variable "binary_authorization" {
  type = object({
    evaluation_mode = string
  })
  description = "the binary authorization evaluation mode(Optional) Mode of operation for Binary Authorization policy evaluation. Valid values are DISABLED and PROJECT_SINGLETON_POLICY_ENFORCE"
}

variable "network_policy" {
  type = object({
    enabled  = bool
    provider = string
  })
  description = "the network policy"
}

variable "datapath_provider" {
  type        = string
  description = "the datapath provider"
  default     = null
}

variable "dns_config" {
  type = map(object({
    cluster_dns        = string
    cluster_dns_scope  = string
    cluster_dns_domain = string
  }))
  description = "the dns config"
}

# gke node pool arguments
variable "pods_secondary_range_name" {
  type        = string
  description = "the pods secondary range name"
}

variable "services_secondary_range_name" {
  type        = string
  description = "the services secondary range name"
}

variable "node_config" {
  description = "Configuration for ondemand and spot nodes"
  type = map(object({
    is_spot                      = bool
    node_count                   = number
    machine_type                 = map(string)
    disk_size_gb                 = number
    disk_type                    = list(string)
    service_account              = string
    oauth_scopes                 = list(string)
    tags                         = list(string)
    shielded_instance_config = object({
      enable_secure_boot          = bool
      enable_integrity_monitoring = bool
    })
    min_node_count = optional(number)
    max_node_count = optional(number)
  }))
}

variable "node_management" {
  description = "Configuration for node management"
  type = object({
    auto_repair  = bool
    auto_upgrade = bool
  })
}

