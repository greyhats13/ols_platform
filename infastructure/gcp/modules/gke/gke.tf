# create a GKE cluster with 2 node pools
resource "google_container_cluster" "cluster" {
  name     = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
  location = var.region

  remove_default_node_pool = var.gke_remove_default_node_pool
  initial_node_count       = var.gke_initial_node_count

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.gke_issue_client_certificate
    }
  }

  # add ip allocation policy
  ip_allocation_policy {
    cluster_secondary_range_name = var.gke_pods_secondary_range_name
    services_secondary_range_name = var.gke_services_secondary_range_name
  }

  network    = var.network_self_link
  subnetwork = var.subnet_self_link
}

# create a ondemand node pool
resource "google_container_node_pool" "ondemand" {
  name       = "${var.unit}-${var.env}-${var.code}-${var.feature[1]}-ondemand"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = var.ondemand_node_count

  node_config {
    preemptible  = false
    machine_type = var.ondemand_machine_type
    disk_size_gb = var.ondemand_disk_size_gb
    disk_type    = var.ondemand_disk_type

    metadata = {
      disable-legacy-endpoints = true
    }

    oauth_scopes = var.ondemand_oauth_scopes

    tags = var.ondemand_tags
  }
}

# create a preemptible node pool
resource "google_container_node_pool" "preemptible" {
  name       = "${var.unit}-${var.env}-${var.code}-${var.feature[1]}-preemptible"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = 0

  node_config {
    preemptible  = true
    machine_type = var.preemptible_machine_type
    disk_size_gb = var.preemptible_disk_size_gb
    disk_type    = var.preemptible_disk_type

    metadata = {
      disable-legacy-endpoints = true
    }

    oauth_scopes = var.preemptible_oauth_scopes

    tags = var.preemptible_tags
  }

  autoscaling {
    min_node_count = var.preemptible_min_node_count
    max_node_count = var.preemptible_max_node_count
  }
}

