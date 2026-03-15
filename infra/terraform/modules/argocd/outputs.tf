output "namespace" {
  description = "Namespace where ArgoCD is deployed"
  value       = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "helm_release_name" {
  description = "Name of the ArgoCD Helm release"
  value       = helm_release.argocd.name
}

output "helm_release_status" {
  description = "Status of the ArgoCD Helm release"
  value       = helm_release.argocd.status
}
