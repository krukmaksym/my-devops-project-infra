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
  timeout    = 600

  create_namespace = false

  # atomic: rolls back the entire release on a failed upgrade.
  # cleanup_on_fail: removes newly-created resources from a failed install
  #   (before a release exists to roll back). Belt-and-suspenders — atomic
  #   handles upgrades, cleanup_on_fail handles first-time installs.
  atomic          = true
  cleanup_on_fail = true
  replace         = var.replace_on_failure

  values = concat(
    [templatefile("${path.module}/values.yaml", {
      lb_source_ranges = var.lb_source_ranges
      server_insecure  = var.server_insecure
      admin_enabled    = var.admin_enabled
      environment      = var.environment
    })],
    var.helm_values
  )
}
