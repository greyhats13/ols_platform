
---

# Google Cloud Storage Terraform Module

This module is designed to create and configure Google Cloud Storage buckets in GCP.

## Features

- Configure bucket names using a combination of business unit, environment, service domain, and feature.
- Set the geographical location of the bucket.
- Option to forcefully delete all objects inside the bucket when destroying the bucket.
- Configure public access prevention for the bucket.

## Usage

### Terraform State Storage

```hcl
terraform {
  backend "gcs" {
    bucket  = "ols-dev-gcloud-storage-tfstate"
    prefix  = "gcs/ols-dev-gcloud-storage-tfstate"
  }
}

module "gcloud-storage-tfstate" {
  source                   = "../../modules/storage/gcloud-storage"
  region                   = "asia-southeast2"
  unit                     = "ols"
  env                      = "dev"
  code                     = "gcloud-storage"
  feature                  = "tfstate"
  force_destroy            = true
  public_access_prevention = "enforced"
}
```

## Inputs

| Name                      | Description                                                   | Type   | Default | Required |
|---------------------------|---------------------------------------------------------------|--------|---------|----------|
| region                    | The geographical location of the bucket.                      | string | -       | Yes      |
| unit                      | Business unit code.                                           | string | -       | Yes      |
| env                       | The stage environment where the infrastructure will be deployed. | string | -       | Yes      |
| code                      | Service domain code.                                          | string | -       | Yes      |
| feature                   | AWS service feature name.                                     | string | -       | Yes      |
| force_destroy             | Delete all objects in the bucket when destroying the bucket.  | bool   | false   | No       |
| public_access_prevention  | Public access prevention to the bucket ('inherited' or 'enforced'). | string | "inherited" | No |

## Outputs

| Name             | Description                       |
|------------------|-----------------------------------|
| bucket_name      | The name of the bucket.           |
| bucket_url       | The URL of the bucket.            |
| bucket_self_link | The link to the bucket resource in GCP. |

---