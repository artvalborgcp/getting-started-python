
resource "google_compute_network" "mygcpnet" {
  project                 = var.project_id
  name                    = "${var.name_prefix}-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "mygcpsubnet" {
  project       = var.project_id
  name          = "${var.name_prefix}-subnet"
  network       = google_compute_network.mygcpnet.id
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  depends_on    = [google_compute_network.mygcpnet]

}

resource "google_compute_firewall" "mygcpnet-allow-http-ssh-rdp-icmp" {
  project = var.project_id
  name    = "${var.name_prefix}-firewall"
  network = google_compute_network.mygcpnet.self_link
  allow {
    protocol = var.firewallallowproto
    ports    = var.firewallallowports
  }
  allow {
    protocol = "icmp"
  }
}


resource "google_compute_router" "mygcprouter" {
  project = var.project_id
  name    = "${var.name_prefix}-router"
  region  = google_compute_subnetwork.mygcpsubnet.region
  network = google_compute_network.mygcpnet.id

}

resource "google_compute_router_nat" "mygcpnat" {
  project                            = var.project_id
  name                               = "${var.name_prefix}-nat"
  router                             = google_compute_router.mygcprouter.name
  region                             = google_compute_router.mygcprouter.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
}


resource "google_compute_global_address" "mygcpglobaladdress" {
  project = var.project_id
  name    = "${var.name_prefix}-address"
}

resource "google_compute_http_health_check" "mygcplbhealth" {
  name         = "${var.name_prefix}-lb-health-check"
  request_path = var.url_map
  port         = var.service_port

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
    group = google_compute_instance_group_manager.instance_group_manager.instance_group
  }
}



resource "google_service_account" "isa" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = "ServiceAccount for compute_instance"
}


resource "google_project_iam_member" "isa-role-storageobjectCreator" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/storage.objectCreator"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-storageobjectViewer" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/storage.objectViewer"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-datastoreuser" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/datastore.user"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-pubsub" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/pubsub.editor"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-sourcereader" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/source.reader"
  project = var.project_id
}

resource "google_project_iam_member" "isa-role-computeadmin" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/compute.loadBalancerAdmin"
  project = var.project_id
}
