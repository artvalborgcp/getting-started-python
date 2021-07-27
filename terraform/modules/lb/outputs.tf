
output "global_ip_address" {
  value       = google_compute_global_address.mygcpglobaladdress.address
  description = "global ip address of Load Balancer"
}
