variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Helm chart version for argo-cd"
  type        = string
}

variable "helm_values" {
  description = "Additional Helm values to pass to the ArgoCD chart"
  type        = list(string)
  default     = []
}
