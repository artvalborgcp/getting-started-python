

output "google_sql_database_instance_ip" {
  value = google_sql_database_instance.instance.ip_address.0.ip_address
}


output "google_sql_database_instance_id" {
  value = google_sql_database_instance.instance.id
}
