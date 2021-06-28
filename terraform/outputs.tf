output "google_sql_database_instance_ip" {
  value = google_sql_database_instance.sqlinstance.ip_address.0.ip_address
}


output "google_sql_database_instance_id" {
  value = google_sql_database_instance.sqlinstance.id
}


output "instance_service_account" {
  description = "Service account for instances."
  value       = google_service_account.isa.name
}
