# Create namespace
resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
  }
}

locals {
  namespace            = var.create_namespace ? kubernetes_namespace.namespace[0].metadata[0].name : var.namespace
  service_account_name = "${var.unit}-${var.env}-${var.code}-${var.feature}"
}

resource "kubernetes_manifest" "manifest" {
  count    = var.create_gmanaged_certificate ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/managed-cert.yaml", { feature = var.feature, namespace = local.namespace, dns_name = var.dns_name }))
}

resource "google_service_account" "gsa" {
  count        = var.create_gservice_account ? 1 : 0
  project      = var.project_id
  account_id   = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  display_name = "Service Account for helm ${var.unit}-${var.env}-${var.code}-${var.feature}"
}

# Assign the specified IAM role to the service account
resource "google_project_iam_member" "sa_iam" {
  count   = var.create_gservice_account ? 1 : 0
  project = var.project_id
  role    = var.google_service_account_role
  member  = "serviceAccount:${google_service_account.gsa[0].email}"
}


# binding service account to service account token creator
resource "google_service_account_iam_binding" "external_dns_binding" {
  count              = var.create_gservice_account && var.use_gworkload_identity ? 1 : 0
  service_account_id = google_service_account.gsa[0].name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${local.namespace}/${local.service_account_name}]"
  ]
}

# binding service account to workload identity
resource "google_service_account_iam_binding" "workload_identity_binding" {
  count              = var.create_gservice_account && var.use_gworkload_identity ? 1 : 0
  service_account_id = google_service_account.gsa[0].name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${local.namespace}/${local.service_account_name}]"
  ]
}

resource "helm_release" "helm" {
  name       = "${var.unit}-${var.release_name}"
  repository = var.repository
  chart      = var.chart
  values = length(var.values) > 0 ? [
    "${templatefile(
      "values.yaml",
      {
        unit                       = var.unit
        env                        = var.env
        code                       = var.code
        feature                    = var.feature
        dns_name                   = var.dns_name
        service_account_annotation = var.create_gservice_account ? google_service_account.gsa[0].email : null
      }
      )
    }"
  ] : []
  namespace = local.namespace
  lint      = true
  dynamic "set" {
    for_each = length(var.helm_sets) > 0 ? {
      for helm_key, helm_set in var.helm_sets : helm_key => helm_set
    } : {}
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

resource "kubernetes_manifest" "after_helm_manifest" {
  count = var.after_helm_manifest != null ? 1 : 0
  manifest = yamldecode(templatefile("${var.after_helm_manifest}", {
    unit      = var.unit,
    env       = var.env,
    code      = var.code,
    feature   = var.feature,
    namespace = local.namespace,
    dns_name  = var.dns_name
  }))
  depends_on = [helm_release.helm]
}
