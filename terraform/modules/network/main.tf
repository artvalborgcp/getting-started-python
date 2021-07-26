resource "google_compute_network" "mygcpnet" {
  project                 = var.project_id
  name                    = "${var.name_prefix}"
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "mygcpsubnet" {
  project       = var.project_id
  name          = "${var.name_prefix}"
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


resource "google_compute_global_address" "mygcpprivate_ip" {
  provider      = google-beta
  project       = var.project_id
  name          = "${var.project_id}-ip-address"
  labels        = var.labels
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.mygcpnet.self_link
}

resource "google_service_networking_connection" "mygcp_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.mygcpnet.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.mygcpprivate_ip.name]
}