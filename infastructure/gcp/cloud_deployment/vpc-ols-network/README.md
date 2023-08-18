
---

# Google Cloud VPC Deployment for OLS Network

This deployment sets up a Google Cloud VPC for the OLS network using the `module/network/vpc` module.

## Overview

- Configures a GCS backend for Terraform state storage.
- Sets up a Google Cloud VPC with custom subnetworks and secondary IP ranges for GKE pods and services.
- Creates a Google Compute Router and NAT for the VPC.
- Configures the Google Cloud provider for Terraform.

## Usage

### Terraform State Storage Configuration

```hcl
terraform {
  backend "gcs" {
    bucket = "ols-dev-gcloud-storage-tfstate"
    prefix = "vpc/ols-dev-vpc-network"
  }
}
```

### Deploying the VPC using the VPC Module

```hcl
module "vpc" {
  source                             = "../../modules/network/vpc"
  region                             = "asia-southeast2"
  unit                               = "ols"
  env                                = "dev"
  code                               = "vpc"
  feature                            = ["network", "subnet", "router", "address", "nat"]
  pods_range_name                    = "pods-range"
  services_range_name                = "services-range"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
```

### Google Cloud Provider Configuration

```hcl
provider "google" {
  project     = "onlineshop-378118"
  region      = "asia-southeast2"
}
```

## Outputs

| Name                 | Description                                          |
|----------------------|------------------------------------------------------|
| vpc_id               | The ID of the VPC being created.                     |
| vpc_self_link        | The URI of the VPC being created.                    |
| vpc_gateway_ipv4     | The IPv4 address of the VPC's gateway.               |
| subnet_self_link     | The URI of the subnetwork.                           |
| subnet_ip_cidr_range | The IP CIDR range of the subnetwork.                 |
| router_id            | The ID of the router.                                |
| router_self_link     | The URI of the router.                               |
| nat_id               | The ID of the NAT.                                   |

---