output "name" {
  description = "Service account name for instances."
  value       = google_service_account.isa.name
}

output "email" {
  description = "Service account email for instances"
  value       = google_service_account.isa.email
}
