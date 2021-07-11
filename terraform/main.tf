module "bucket" {
  source        = "./modules/bucket"
  project_id    = var.project_id
  labels        = var.labels
  storage_class = var.storage_class
  location      = var.location
}

module "sa" {
  source     = "./modules/iam"
  project_id = var.project_id
  account_id = var.account_id
}

module "network" {
  source               = "./modules/network"
  project_id           = var.project_id
  region               = var.region
  zone                 = var.zone
  name_prefix          = var.name_prefix
  firewallallowproto   = var.firewallallowproto
  globalforwardingport = var.globalforwardingport
  ip_cidr_range        = var.ip_cidr_range
  service_port         = var.service_port
  service_port_name    = var.service_port_name
}

module "instances" {
  source                  = "./modules/instances"
  name_prefix             = var.name_prefix
  account_id              = var.account_id
  project_id              = var.project_id
  machine_type            = var.machine_type
  region                  = var.region
  tags                    = var.tags
  can_ip_forward          = var.can_ip_forward
  labels                  = var.labels
  metadata_startup_script = var.metadata_startup_script
  service_port            = var.service_port
  service_port_name       = var.service_port_name
  zone                    = var.zone
  sa_compute_scope        = var.sa_compute_scope
  source_image            = var.source_image
  auto_delete             = var.auto_delete
  disk_size_gb            = var.disk_size_gb
  disk_type               = var.disk_type
  boot                    = var.boot
  db_name_prefix          = var.db_name_prefix
  databackend             = var.databackend
  user_name               = var.user_name
  user_password           = var.user_password
}

module "sql" {
  source              = "./modules/sql"
  db_name_prefix      = var.db_name_prefix
  project_id          = var.project_id
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection
  tier                = var.tier
  name_prefix         = var.name_prefix
  user_name           = var.user_name
  user_password       = var.user_password
}



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
    group = module.instances.instance_group
  }
}


resource "google_compute_global_address" "mygcpprivate_ip" {
  provider      = google-beta
  project       = var.project_id
  name          = "${var.project_id}-ip-address"
  labels        = var.labels
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.network.network_self_link
}

resource "google_service_networking_connection" "mygcp_vpc_connection" {
  provider = google-beta

  network                 = module.network.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.mygcpprivate_ip.name]
}