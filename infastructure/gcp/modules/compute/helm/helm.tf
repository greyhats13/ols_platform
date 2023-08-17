resource "helm_release" "helm" {
  name       = "${var.unit}-${var.env}-${var.code}-${var.feature}"
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
}