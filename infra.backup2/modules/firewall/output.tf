output "firewall_internal" {
  value = google_compute_firewall.allow_internal.name
}

output "firewall_ssh" {
  value = google_compute_firewall.allow_ssh.name
}
