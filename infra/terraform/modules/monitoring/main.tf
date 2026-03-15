resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.monitoring_namespace
    labels = {
      name = var.monitoring_namespace
    }
  }
}

resource "helm_release" "victoria_metrics_k8s_stack" {
  name       = "vm-stack"
  repository = "https://victoriametrics.github.io/helm-charts/"
  chart      = "victoria-metrics-k8s-stack"
  version    = var.vm_stack_chart_version
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  timeout    = 1800

  # We use 'create_namespace = false' because we manage it with kubernetes_namespace above
  create_namespace = false

  # Automatically rollback to previous release on failure instead of leaving
  # a broken FAILED release in the cluster (and stuck Terraform state).
  atomic          = true
  cleanup_on_fail = true

  # Allow Terraform to clean up a previously failed release before retrying.
  # Without this, a FAILED release blocks all subsequent applies.
  replace = true

  values = concat(
    [templatefile("${path.module}/values.yaml", {
      retention_period = var.retention_period
    })],
    var.helm_values
  )
}
