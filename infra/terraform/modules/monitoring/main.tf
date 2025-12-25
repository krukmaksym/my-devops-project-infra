resource "kubernetes_namespace" "monitoring" {
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
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  timeout    = 900

  # We use 'create_namespace = false' because we manage it with kubernetes_namespace above
  create_namespace = false

  values = concat(
    [templatefile("${path.module}/values.yaml", {
      retention_period = var.retention_period
    })],
    var.helm_values
  )
}
