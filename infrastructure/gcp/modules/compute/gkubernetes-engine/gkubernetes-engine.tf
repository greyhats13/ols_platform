# create a GKE cluster with 2 node pools
resource "google_container_cluster" "cluster" {
  name     = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  location = var.env == "dev" ? "${var.region}-a" : var.region

  remove_default_node_pool = var.env == "dev" ? false : true
  initial_node_count       = 1
  master_auth {
    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config
    content {
      enable_private_endpoint = var.env == "dev" ? false:each.value.enable_private_endpoint
      enable_private_nodes    = each.value.enable_private_nodes
      master_ipv4_cidr_block  = each.value.master_ipv4_cidr_block
    }
  }

  binary_authorization {
    evaluation_mode = var.binary_authorization_evaluation_mode
  }

  # add ip allocation policy
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  network    = var.vpc_self_link
  subnetwork = var.subnet_self_link
}

locals {
  node_config = var.env == "dev" ? { spot = var.node_config["spot"] } : var.node_config
}

# create a ondemand node pool
resource "google_container_node_pool" "nodepool" {
  for_each   = local.node_config
  name       = each.key
  location   = var.env == "dev" ? "${var.region}-a" : var.region
  cluster    = google_container_cluster.cluster.name
  node_count = var.env == "dev" ? 2 : each.value.node_count

  node_config {
    machine_type = var.env == "dev" ? each.value.machine_type[0] : (
              var.env == "stg" ? each.value.machine_type[1] : each.value.machine_type[2]
            )
    disk_size_gb = each.value.disk_size_gb
    disk_type    = var.env == "dev" ? each.value.disk_type[0] : each.value.disk_type[1]
    oauth_scopes = each.value.oauth_scopes
    tags         = each.value.tags
  }

  dynamic "autoscaling" {
    for_each = each.key == "spot" ? [1] : [0]  
    content {
      min_node_count = var.env == "dev" ? 2 : each.value.node_count
      max_node_count = each.value.max_node_count
    }
  }
}

#solving bug from: https://github.com/hashicorp/terraform-provider-kubernetes/issues/1424

data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.cluster.endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
}

resource "kubernetes_cluster_role_binding" "client_cluster_admin" {
  metadata {
    annotations = {}
    labels      = {}
    name        = "client-cluster-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "client"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "kube-system"
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}

