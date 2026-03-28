resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.argocd_namespace
    labels = {
      name = var.argocd_namespace
    }
  }
}

# Pre-create the Redis auth secret so the redisSecretInit pre-install job
# can be disabled.  The job is a known source of failures in the argo-cd
# chart (ref: argoproj/argo-helm#2848).
resource "random_password" "redis" {
  length  = 16
  special = false
}

resource "kubernetes_secret_v1" "argocd_redis" {
  metadata {
    name      = "argocd-redis"
    namespace = kubernetes_namespace_v1.argocd.metadata[0].name
  }

  data = {
    auth = random_password.redis.result
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
  depends_on       = [kubernetes_secret_v1.argocd_redis]

  # atomic: rolls back the entire release on a failed upgrade.
  # cleanup_on_fail: removes newly-created resources from a failed install
  #   (before a release exists to roll back). Belt-and-suspenders — atomic
  #   handles upgrades, cleanup_on_fail handles first-time installs.
  atomic          = true
  cleanup_on_fail = true
  replace         = var.replace_on_failure

  values = [templatefile("${path.module}/values.yaml", {
    lb_source_ranges       = var.lb_source_ranges
    server_insecure        = var.server_insecure
    admin_enabled          = var.admin_enabled
    environment            = var.environment
    dex_enabled            = var.github_oauth_client_id != ""
    argocd_url             = var.argocd_url
    github_oauth_client_id = var.github_oauth_client_id
    github_org             = var.github_org
    github_admin_team      = var.github_admin_team
  })]

  # Keep the OAuth client secret out of the rendered values YAML and
  # Terraform plan output.  ArgoCD's dex.config references it as
  # $dex.github.clientSecret, which resolves at runtime from argocd-secret.
  set_sensitive = var.github_oauth_client_secret != "" ? [
    {
      name  = "configs.secret.extra.dex\\.github\\.clientSecret"
      value = var.github_oauth_client_secret
    }
  ] : []
}

# Bootstrap the App-of-Apps root Application via the argocd-apps Helm chart.
# Using a helm_release (rather than kubernetes_manifest) avoids the CRD-at-plan-time
# issue: Helm only creates the Application resources during apply, after the ArgoCD
# Helm release above has already installed the argoproj.io CRDs.
resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.2"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name

  depends_on = [helm_release.argocd]

  atomic          = true
  cleanup_on_fail = true

  values = [yamlencode({
    applications = [
      {
        name       = "root-app"
        project    = "default"
        finalizers = ["resources-finalizer.argocd.argoproj.io"]
        source = {
          repoURL        = var.gitops_repo_url
          targetRevision = var.gitops_revision
          path           = "gitops/apps/${var.environment}"
        }
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = kubernetes_namespace_v1.argocd.metadata[0].name
        }
        syncPolicy = {
          automated = {
            prune    = true
            selfHeal = true
          }
        }
      }
    ]
  })]
}
