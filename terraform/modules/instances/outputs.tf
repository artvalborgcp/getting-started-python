
output instance_template {
  description = "Link to the instance_template for the group"
  value       = "${google_compute_instance_template.tpl.*.self_link}"
}

output instance_group {
  description = "Link to the `instance_group` property of the instance group manager resource."
  value       = "${element(concat(google_compute_instance_group_manager.instance_group_manager.*.instance_group, tolist([""])), 0)}"
}

