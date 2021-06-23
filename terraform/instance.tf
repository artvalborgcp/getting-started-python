resource "google_compute_instance_template" "tpl" {
  name                    = var.name_prefix
  project                 = var.project_id
  machine_type            = var.machine_type
  region                  = var.region
  tags                    = var.tags
  can_ip_forward          = var.can_ip_forward
  labels                  = var.labels
  metadata_startup_script = file(var.metadata_startup_script)

  disk {
    source_image = var.source_image
    auto_delete  = var.auto_delete
    disk_size_gb = var.disk_size_gb
    boot         = true
  }
  depends_on = [google_compute_subnetwork.mygcpsubnet]
  network_interface {
    network    = var.network_name
    subnetwork = var.subnetname
    #  access_config {
    #  }
  }

  service_account {

    email  = google_service_account.isa.email
    scopes = ["cloud-platform"]
  }

}


resource "google_compute_health_check" "autohealing" {
  name                = "${var.name_prefix}-health-check"
  project             = var.project_id
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = var.service_port
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = var.name_prefix
  base_instance_name = var.name_prefix
  zone               = var.zone
  target_size        = var.target_size
  named_port {
    name = var.service_port_name
    port = var.service_port
  }
  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
  version {
    instance_template = google_compute_instance_template.tpl.id
  }

  depends_on = [google_service_account.isa]

}



resource "google_storage_bucket" "bucket" {
  name          = "${var.project_id}-bucket"
  project       = var.project_id
  labels        = var.labels
  storage_class = var.storage_class
  location      = var.location

}
