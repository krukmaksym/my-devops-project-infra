output "namespace" {
  description = "Namespace where monitoring stack is deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "helm_release_name" {
  description = "Name of the Helm release"
  value       = helm_release.victoria_metrics_k8s_stack.name
}

output "helm_release_status" {
  description = "Status of the Helm release"
  value       = helm_release.victoria_metrics_k8s_stack.status
}
