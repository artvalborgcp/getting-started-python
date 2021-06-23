
resource "google_compute_network" "mygcpnet" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "mygcpsubnet" {
  project       = var.project_id
  name          = var.subnetname
  network       = google_compute_network.mygcpnet.id
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  depends_on    = [google_compute_network.mygcpnet]

}

resource "google_compute_firewall" "mygcpnet-allow-http-ssh-rdp-icmp" {
  project = var.project_id
  name    = var.firewall
  network = google_compute_network.mygcpnet.self_link
  allow {
    protocol = "tcp"
    ports    = var.firewallports
  }
  allow {
    protocol = "icmp"
  }
}


resource "google_compute_router" "mygcprouter" {
  project = var.project_id
  name    = var.routername
  region  = google_compute_subnetwork.mygcpsubnet.region
  network = google_compute_network.mygcpnet.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "mygcpnat" {
  project                            = var.project_id
  name                               = var.natname
  router                             = google_compute_router.mygcprouter.name
  region                             = google_compute_router.mygcprouter.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


resource "google_compute_global_address" "default" {
  project      = var.project_id
  name         = "${var.name_prefix}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_http_health_check" "default" {
  name         = "authentication-health-check"
  request_path = var.url_map
  port         = var.service_port

  timeout_sec        = 1
  check_interval_sec = 1
}

resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.default.id
    }
  }
}

resource "google_compute_target_http_proxy" "http" {
  count   = "1"
  project = var.project_id
  name    = "${var.name_prefix}-http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "http" {

  project    = var.project_id
  name       = "${var.name_prefix}-http-rule"
  target     = google_compute_target_http_proxy.http[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"


  depends_on = [google_compute_global_address.default]

}

resource "google_compute_backend_service" "default" {
  name          = "${var.name_prefix}-backend-service"
  project       = var.project_id
  port_name     = var.service_port_name
  protocol      = "HTTP"
  timeout_sec   = 10
  health_checks = [google_compute_http_health_check.default.id]
  backend {
    group = google_compute_instance_group_manager.instance_group_manager.instance_group
  }
}


resource "google_project_default_service_accounts" "my_project" {
  project = var.project_id
  action  = var.action
}

resource "google_service_account" "isa" {
  project      = var.project_id
  account_id   = "compute-instance"
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
