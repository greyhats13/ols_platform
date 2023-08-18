
---

# Google Cloud Storage Terraform Deployment for Terraform State Storage

This deployment utilizes the Google Cloud Storage Terraform module to create a backend for storing Terraform state files (`tfstate`).

## Overview

- Configures a GCS bucket to store Terraform state files.
- Uses the Google Cloud Storage Terraform module for bucket creation.
- Sets up the Google Cloud provider for Terraform.

## Usage

### Terraform State Storage Configuration

```hcl
terraform {
  backend "gcs" {
    bucket  = "ols-dev-gcloud-storage-tfstate"
    prefix  = "gcs/ols-dev-gcloud-storage-tfstate"
  }
}
```

### Create GCS Bucket using the GCloud Storage Module

```hcl
module "gcloud-storage-tfstate" {
  source                   = "../../modules/storage/gcloud-storage"
  region                   = "<GCP Region>"
  unit                     = "<Business Unit Code>"
  env                      = "<Environment>"
  code                     = "<Service Domain Code>"
  feature                  = "<Feature Name>"
  force_destroy            = true
  public_access_prevention = "enforced"
}
```

### Google Cloud Provider Configuration

```hcl
provider "google" {
  project     = "<GCP Project ID>"
  region      = "<GCP Region>"
}
```

## Outputs

| Name             | Description                       |
|------------------|-----------------------------------|
| bucket_name      | The name of the GCS bucket.       |
| bucket_url       | The URL of the GCS bucket.        |
| bucket_self_link | The link to the bucket resource in GCP. |

---