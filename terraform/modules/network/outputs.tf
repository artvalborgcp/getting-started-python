output "subnet" {
  value       = google_compute_subnetwork.mygcpsubnet
  description = "Subnetwork of the created network "
}


output "network" {
  value       = google_compute_network.mygcpnet
  description = "Created network"
}

output "network_id" {
  value       = google_compute_network.mygcpnet.id
  description = "Created network id"
}

output "network_name" {
  value       = google_compute_network.mygcpnet.name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.mygcpnet.self_link
  description = "The URI of the VPC being created"
}