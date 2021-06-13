output "bookshelfinstance_ip" {
  value = google_compute_instance_from_template.tpl.network_interface.0.network_ip
}

output "bookshelfinstance_id" {
  value = google_compute_instance_from_template.tpl.id
}


output "instance_service_account" {
  description = "Service account for instances."
  value       = google_service_account.isa.name
}
