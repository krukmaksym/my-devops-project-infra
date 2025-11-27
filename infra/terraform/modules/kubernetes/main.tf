resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "${var.environment}-cluster"
  region  = var.region
  version = var.k8s_version

  vpc_uuid = var.vpc_id

  surge_upgrade = true
  auto_upgrade  = true

  maintenance_policy {
    day        = "saturday"
    start_time = "03:00"
  }

  # Default application node pool
  node_pool {
    name       = "${var.environment}-app-pool"
    size       = var.node_size
    node_count = var.node_count

    auto_scale = var.auto_scale
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes

    labels = merge(
      var.node_pool_labels,
      {
        service  = "app"
        priority = "high"
      },
    )

    tags = var.tags

    taint {
      key    = "service"
      value  = "app"
      effect = "NoSchedule"
    }
  }
  
  lifecycle {
    prevent_destroy = true
  }
}

# Dedicated node pool for monitoring stack (Prometheus, Grafana, Alertmanager, etc.)
resource "digitalocean_kubernetes_node_pool" "monitoring" {
  cluster_id = digitalocean_kubernetes_cluster.k8s.id

  name       = "${var.environment}-monitoring-pool"
  size       = var.monitoring_node_size
  node_count = var.monitoring_node_count

  auto_scale = var.monitoring_auto_scale
  min_nodes  = var.monitoring_min_nodes
  max_nodes  = var.monitoring_max_nodes

  labels = merge(
    var.node_pool_labels,
    {
      service  = "monitoring"
      priority = "low"
    },
  )

  taint {
    key    = "service"
    value  = "monitoring"
    effect = "NoSchedule"
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}