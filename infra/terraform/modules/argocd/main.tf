resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.argocd_namespace
    labels = {
      name = var.argocd_namespace
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  timeout    = 1800

  create_namespace = false

  atomic  = true
  replace = true

  values = concat(
    [templatefile("${path.module}/values.yaml", {
      lb_source_ranges = var.lb_source_ranges
    })],
    var.helm_values
  )
}
