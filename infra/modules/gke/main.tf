resource "google_container_cluster" "gke_cluster" {
  name       = var.cluster_name
  location   = var.zone
  network    = var.vpc_name
  subnetwork = var.subnet_name

  ip_allocation_policy {}

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  network_policy {
    enabled  = true
    provider = "CALICO"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.zone

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size_gb
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    preemptible  = false
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  initial_node_count = var.min_node_count
}
