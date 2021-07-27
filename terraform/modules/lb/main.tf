resource "google_compute_global_address" "mygcpglobaladdress" {
  project = var.project_id
  name    = "${var.name_prefix}-address"
}

resource "google_compute_http_health_check" "mygcplbhealth" {
  name               = "${var.name_prefix}-lb-health-check"
  request_path       = var.url_map
  port               = var.service_port
  timeout_sec        = var.timeout_mygcplb
  check_interval_sec = var.check_interval_mygcplb
}

resource "google_compute_url_map" "url" {
  name            = "${var.name_prefix}-url"
  default_service = google_compute_backend_service.backendservice.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backendservice.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.backendservice.id
    }
  }
}

resource "google_compute_target_http_proxy" "http" {
  project = var.project_id
  name    = "${var.name_prefix}-http-proxy"
  url_map = google_compute_url_map.url.id
}

resource "google_compute_global_forwarding_rule" "http" {

  project    = var.project_id
  name       = "${var.name_prefix}-http-rule"
  target     = google_compute_target_http_proxy.http.id
  ip_address = google_compute_global_address.mygcpglobaladdress.address
  port_range = var.globalforwardingport
  depends_on = [google_compute_global_address.mygcpglobaladdress]

}

resource "google_compute_backend_service" "backendservice" {
  name          = "${var.name_prefix}-backend-service"
  project       = var.project_id
  port_name     = var.service_port_name
  protocol      = var.protocol_backendservice
  timeout_sec   = var.timeout_backendservice
  health_checks = [google_compute_http_health_check.mygcplbhealth.id]
  backend {
    group = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/zones/${var.zone}/instanceGroups/${var.name_prefix}"
  }
}
