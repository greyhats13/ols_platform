# Infrastructure for GCP

This directory contains Terraform configurations for deploying resources on Google Cloud Platform (GCP). The configurations are modularized into different components to ensure reusability and maintainability.

## Modules

### 1. **VPC (Virtual Private Cloud)**
- **File**: `modules/vpc/vpc.tf`
  - Creates a VPC.
  - Sets up a subnet within the VPC.
  - Configures secondary IP ranges for GKE pods and services.

- **Variables**: `modules/vpc/variables.tf`
  - Defines naming standards and subnet arguments.

- **Outputs**: `modules/vpc/outputs.tf`
  - Provides outputs for VPC ID, VPC self link, VPC gateway IPv4, and subnetwork details.

### 2. **GCE (Google Compute Engine)**
- **File**: `modules/gce/gce.tf`
  - Sets up a bastion host.
  - Configures a firewall rule to allow SSH access to the bastion host.

- **Variables**: `modules/gce/variables.tf`
  - Defines naming standards and GCE-specific arguments.

### 3. **GKE (Google Kubernetes Engine)**
- **File**: `modules/gke/gke.tf`
  - Creates a GKE cluster with two node pools: on-demand and preemptible.
  - Configures node pools with specific machine types, tags, and OAuth scopes.

- **Variables**: `modules/gke/variables.tf`
  - Defines naming standards and GKE-specific arguments.

## Deployment

### How to Deploy

1. **Initialize Terraform**:
   Navigate to the `deployment` directory and run:
   ```bash
   terraform init
   ```

2. **Plan Deployment**:
   Review the changes that will be made by Terraform:
   ```bash
   terraform plan
   ```

3. **Apply Changes**:
   Deploy the infrastructure:
   ```bash
   terraform apply
   ```
   Confirm the deployment by typing `yes` when prompted.

4. **Destroy Infrastructure (Optional)**:
   If you need to tear down the infrastructure:
   ```bash
   terraform destroy
   ```
   Confirm the destruction by typing `yes` when prompted.

- **Main Configuration**: `deployment/main.tf`
  - Uses the above modules to deploy a VPC, GCE bastion host, and GKE cluster.

- **Providers**: `deployment/providers.tf`
  - Sets up the GCP provider with specific credentials, project, and region.

---

This README provides an overview of the Terraform configurations in the `infrastructure/gcp` directory. For detailed configurations and customizations, refer to the respective Terraform files within each module.

---