resource "google_compute_instance_template" "tpl" {
  name           = var.name_prefix
  project        = var.project_id
  machine_type   = var.machine_type
  region         = var.region
  tags           = var.tags
  can_ip_forward = var.can_ip_forward
  labels         = var.labels
  metadata = {
    PROJECT_ID           = var.project_id
    region               = var.region
    zone                 = var.zone
    DATA_BACKEND         = var.databackend
    CLOUD_STORAGE_BUCKET = "${var.project_id}-bucket"
  }
  metadata_startup_script = file(var.metadata_startup_script)

  disk {
    source_image = var.source_image
    auto_delete  = var.auto_delete
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    boot         = var.boot
  }
  depends_on = [google_compute_subnetwork.mygcpsubnet]
  network_interface {
    network    = google_compute_network.mygcpnet.name
    subnetwork = google_compute_subnetwork.mygcpsubnet.name

  }

  service_account {

    email  = google_service_account.isa.email
    scopes = var.sa_compute_scope
  }

}


resource "google_compute_health_check" "instance" {
  name                = "${var.name_prefix}-instance-health-check"
  project             = var.project_id
  check_interval_sec  = var.check_interval_sec_instance
  timeout_sec         = var.timeout_sec_instance
  healthy_threshold   = var.healthy_threshold_instance
  unhealthy_threshold = var.unhealthy_threshold_instance

  http_health_check {
    request_path = var.url_map
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
    health_check      = google_compute_health_check.instance.id
    initial_delay_sec = var.initial_delay_sec
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
