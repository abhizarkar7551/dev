# Project ID
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

# Region
variable "region" {
  description = "The GCP region to deploy the cluster"
  type        = string
  default     = "us-central1"
}

# Zone
variable "zone" {
  description = "The GCP zone to deploy the cluster"
  type        = string
  default     = "us-central1-a"
}

# Node Pool Settings
variable "node_machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_disk_size_gb" {
  description = "Disk size for node VMs"
  type        = number
  default     = 100
}

variable "min_node_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
  default     = 2
}

variable "max_node_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
  default     = 3
}

# VPC and Subnet
variable "vpc_name" {
  description = "Name of the VPC to create"
  type        = string
  default     = "gke-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet to create"
  type        = string
  default     = "gke-subnet"
}

variable "subnet_ip_cidr" {
  description = "IP CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/16"
}
