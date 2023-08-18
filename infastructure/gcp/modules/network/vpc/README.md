
---

# Google Cloud VPC Terraform Module

This module provides Terraform configurations for creating a VPC in Google Cloud Platform (GCP) with the necessary configurations for GKE clusters. It sets up a VPC, subnetwork, router, Cloud NAT, and custom routes.

## Overview

- Creates a VPC in GCP.
- Configures a subnetwork within the VPC with CIDR ranges that vary based on the environment (`var.env`).
- Sets up a router for the VPC.
- Configures Cloud NAT for the VPC.
- Creates custom routes to internet gateway for the VPC.

## Usage

```hcl
terraform {
  backend "gcs" {
    bucket  = "<Bucket name for storing tfstate>"
    prefix  = "<prefix of the bucket e.g vpc/ols-dev-vpc-network>"
  }
}

module "vpc" {
  source                   = "../../modules/network/vpc"
  region                   = "<GCP Region>"
  unit                     = "<Business Unit Code>"
  env                      = "<Environment: dev, stg, or prod>"
  code                     = "vpc"
  feature                  = "<Feature Name>"
  pods_range_name          = "pods-range"
  services_range_name      = "services-range"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | The GCP region where resources will be created. | `string` | n/a | yes |
| unit | Business unit code. | `string` | n/a | yes |
| env | Stage environment where the infrastructure will be deployed. Determines the CIDR ranges. Valid values: `dev`, `stg`, `prod`. | `string` | n/a | yes |
| code | Service domain code. | `string` | n/a | yes |
| feature | Feature names. | `list(string)` | n/a | yes |
| pods_range_name | The name of the pods range. | `string` | n/a | yes |
| services_range_name | The name of the services range. | `string` | n/a | yes |
| nat_ip_allocate_option | The way NAT IPs should be allocated. | `string` | n/a | yes |
| source_subnetwork_ip_ranges_to_nat | How to allocate NAT IPs. | `string` | n/a | yes |
| subnetworks | List of subnetworks to configure NAT for. | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC being created. |
| vpc_self_link | The URI of the VPC being created. |
| vpc_gateway_ipv4 | The IPv4 address of the VPC's gateway. |
| subnet_network | The network to which this subnetwork belongs. |
| subnet_self_link | The URI of the subnetwork. |
| subnet_ip_cidr_range | The IP CIDR range of the subnetwork. |
| router_id | The ID of the router being created. |
| router_self_link | The URI of the router being created. |
| nat_id | The ID of the NAT being created. |
| route_id | The ID of the route being created. |
| route_next_hop_gateway | The next hop to the destination network. |
| route_self_link | The URI of the route being created. |

---