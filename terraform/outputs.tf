output "bookshelfinstance_ip" {
  value = google_compute_instance_from_template.tpl.network_interface.0.network_ip
}

output "google_sql_database_instance_ip" {
  value = google_sql_database_instance.instance.ip_address.0.ip_address
}
output "bookshelfinstance_id" {
  value = google_compute_instance_from_template.tpl.id
}

output "google_sql_database_instance_id" {
  value = google_sql_database_instance.instance.id
}

output "instance_service_account" {
  description = "Service account for instances."
  value       = google_service_account.isa.name
}
