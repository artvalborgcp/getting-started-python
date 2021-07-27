resource "google_compute_instance_template" "tpl" {
  name           = var.name_prefix
  project        = var.project_id
  machine_type   = var.machine_type
  region         = var.region
  tags           = var.tags
  can_ip_forward = var.can_ip_forward
  labels         = var.labels
  metadata = {
    PROJECT_ID               = var.project_id
    region                   = var.region
    zone                     = var.zone
    DATA_BACKEND             = var.databackend
    CLOUD_STORAGE_BUCKET     = "${var.project_id}-bucket"
    CLOUDSQL_USER            = var.user_name
    CLOUDSQL_PASSWORD        = var.user_password
    CLOUDSQL_DATABASE        = var.db_name_prefix
    CLOUDSQL_CONNECTION_NAME = "${var.project_id}:${var.region}:${var.db_name_prefix}"
  }
  metadata_startup_script = file(var.metadata_startup_script)

  disk {
    source_image = var.source_image
    auto_delete  = var.auto_delete
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    boot         = var.boot
  }
  network_interface {
    network    = var.name_prefix
    subnetwork = var.name_prefix

  }

  service_account {
    email  = "${var.account_id}@${var.project_id}.iam.gserviceaccount.com"
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
}
