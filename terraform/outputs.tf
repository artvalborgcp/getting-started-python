output "google_sql_database_instance_ip" {
  value       = module.sql.google_sql_database_instance_ip
  description = "The database instance ip address "
}


output "google_sql_database_instance_id" {
  value       = module.sql.google_sql_database_instance_id
  description = "The sql instance name "
}

output "instance_connection_name" {
  value       = module.sql.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "global_ip_address" {
  value       = module.lb.global_ip_address
  description = "global ip address of Load Balancer"
}

output "project_id" {
  description = "Project sample project id."
  value       = var.project_id
}

output "sa" {
  description = "Project SA email"
  value       = module.sa.email
}