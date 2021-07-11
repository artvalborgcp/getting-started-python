output "google_sql_database_instance_ip" {
  value       = google_sql_database_instance.sqlinstance.ip_address.0.ip_address
  description = "The database instance ip address "
}


output "google_sql_database_instance_id" {
  value       = google_sql_database_instance.sqlinstance.id
  description = "The sql instance name "
}




output "instance_connection_name" {
  value       = google_sql_database_instance.sqlinstance.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

