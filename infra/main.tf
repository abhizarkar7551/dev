provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# -----------------------------
# VPC and Subnet
# -----------------------------
resource "google_compute_network" "gke_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_cidr
  region        = var.region
  network       = google_compute_network.gke_vpc.id
}

# -----------------------------
# Firewall Rules
# -----------------------------
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.gke_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.subnet_ip_cidr]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.gke_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# -----------------------------
# GKE Cluster
# -----------------------------
resource "google_container_cluster" "gke_cluster" {
  name       = "gke-standard-cluster"
  location   = var.zone
  network    = google_compute_network.gke_vpc.name
  subnetwork = google_compute_subnetwork.gke_subnet.name

  ip_allocation_policy {}

  remove_default_node_pool = true
  initial_node_count       = 1  # Required by GKE API even if we remove default node pool

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  network_policy {
    enabled  = true
    provider = "CALICO"
  }
}

# -----------------------------
# Custom Node Pool with Autoscaling
# -----------------------------
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.zone

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size_gb
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    preemptible = false
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
