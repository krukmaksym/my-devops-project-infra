output "cluster_id" {
  description = "ID of the DigitalOcean Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s.id
}

output "app_node_pool_id" {
  description = "ID of the application node pool"
  value       = digitalocean_kubernetes_cluster.k8s.node_pool[0].id
}

output "monitoring_node_pool_id" {
  description = "ID of the monitoring node pool"
  value       = digitalocean_kubernetes_node_pool.monitoring.id
}


output "endpoint" {
  description = "API server endpoint of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s.endpoint
}

output "kubeconfig" {
  description = "Raw kubeconfig for the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s.kube_config[0].raw_config
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "CA certificate for the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_token" {
  description = "Access token for the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s.kube_config[0].token
  sensitive   = true
}