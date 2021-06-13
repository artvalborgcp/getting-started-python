
resource "google_compute_global_address" "mygcpprivate_ip" {
  provider = google-beta

  name          = "mygcpprivate-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.mygcpnet.id
}

resource "google_service_networking_connection" "mygcp_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.mygcpnet.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.mygcpprivate_ip.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name    = var.name_db
  project = var.project_id

  depends_on = [google_service_networking_connection.mygcp_vpc_connection]

  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.mygcpnet.id
    }
  }
}

provider "google-beta" {
  region  = "us-central1"
  zone    = "us-central1-a"
  project = "my-gcp-terraform"
}
