
---

# Google Cloud VPC Terraform Module

This module provisions a Google Cloud VPC and its associated subnetwork, optimized for GKE usage with dedicated IP CIDR ranges for pods and services.

## Features

- Creates a VPC in Google Cloud.
- Provisions a subnetwork within the VPC.
- Allows for custom naming based on business unit, environment, service domain, and feature.
- Configures secondary IP ranges for GKE pods and services.

## Usage

```hcl
terraform {
  backend "gcs" {
    bucket  = "<Bucket name for storing tfstate>"
    prefix  = "<prefix of the bucket>"
  }
}

module "vpc" {
  source                   = "../../modules/network/vpc"
  region                   = "<GCP Region>"
  unit                     = "<Business Unit Code>"
  env                      = "<Environment>"
  code                     = "vpc"
  feature                  = "<Feature Name>"
  subnetwork_ip_cidr_range = "10.0.0.0/16"
  pods_range_name          = "pods-range"
  pods_ip_cidr_range       = "172.16.0.0/16"
  services_range_name      = "services-range"
  services_ip_cidr_range   = "172.17.0.0/16"
}
```

## Inputs

| Name                     | Description                                                   | Type   | Default | Required |
|--------------------------|---------------------------------------------------------------|--------|---------|----------|
| region                   | The GCP region where resources will be created.               | string | -       | Yes      |
| unit                     | Business unit code.                                           | string | -       | Yes      |
| env                      | Stage environment where the infrastructure will be deployed.  | string | -       | Yes      |
| code                     | Service domain code.                                          | string | -       | Yes      |
| feature                  | Feature name.                                                 | list of string | -       | Yes      |
| subnetwork_ip_cidr_range | The IP CIDR range of the subnetwork.                          | string | -       | Yes      |
| pods_range_name          | The name of the pods range.                                   | string | -       | Yes      |
| services_range_name      | The name of the services range.                               | string | -       | Yes      |
| pods_ip_cidr_range       | IP CIDR range for GKE pods.                                   | string | -       | Yes      |
| services_ip_cidr_range   | IP CIDR range for GKE services.                               | string | -       | Yes      |

## Outputs

| Name               | Description                                   |
|--------------------|-----------------------------------------------|
| vpc_id             | The ID of the created VPC.                    |
| vpc_self_link      | The URI of the created VPC.                   |
| vpc_gateway_ipv4   | The IPv4 address of the VPC's gateway.        |
| subnet_network     | The network to which the subnetwork belongs.  |
| subnet_self_link   | The URI of the subnetwork.                    |
| subnet_ip_cidr_range | The IP CIDR range of the subnetwork.        |

---