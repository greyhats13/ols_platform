resource "google_service_account" "gsa" {
  count        = var.create_service_account ? 1 : 0
  project      = var.project_id
  account_id   = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  display_name = "Service Account for helm ${var.unit}-${var.env}-${var.code}-${var.feature}"
}

# Assign the specified IAM role to the service account
resource "google_project_iam_member" "sa_iam" {
  count   = var.create_service_account ? 1 : 0
  project = var.project_id
  role    = var.service_account_role
  member  = "serviceAccount:${google_service_account.gsa[0].email}"
}

resource "kubernetes_service_account" "ksa" {
  count = var.create_service_account ? 1 : 0
  metadata {
    name      = "${var.unit}-${var.env}-${var.code}-${var.feature}"
    namespace = var.namespace
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "external_dns" {
  count = var.create_service_account ? 1 : 0
  metadata {
    name = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  }

  dynamic "rule" {
    for_each = var.kubernetes_cluster_role_rules != {} ? [var.kubernetes_cluster_role_rules] : []
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_cluster_role_binding" "external_dns" {
  count = var.create_service_account ? 1 : 0
  metadata {
    name = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns[0].metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_cluster_role.external_dns[0].metadata[0].name
    namespace = var.namespace
  }
}


resource "helm_release" "helm" {
  name       = "${var.unit}-${var.release_name}"
  repository = var.repository
  chart      = var.chart
  values     = length(var.values) > 0 ? var.values : []
  namespace  = var.namespace
  lint       = true
  dynamic "set" {
    for_each = length(var.helm_sets) > 0 ? {
      for helm_key, helm_set in var.helm_sets : helm_key => helm_set
    } : {}
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
  create_namespace = var.create_namespace
}
