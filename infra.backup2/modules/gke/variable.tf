variable "cluster_name" { type = string }
variable "zone" { type = string }
variable "vpc_name" { type = string }
variable "subnet_name" { type = string }
variable "node_machine_type" { type = string }
variable "node_disk_size_gb" { type = number }
variable "min_node_count" { type = number }
variable "max_node_count" { type = number }
