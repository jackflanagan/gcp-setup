output "external_ip" {
  description = "External IP created"
  value       = google_compute_address.ip_address.address
}

output "subnet_name" {
  description = "Name of the subnet"
  value = google_compute_subnetwork.subnet1.name
}