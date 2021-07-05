


resource "google_compute_global_address" "mygcpprivate_ip" {
  provider      = google-beta
  project       = var.project_id
  name          = "${var.project_id}-ip-address"
  labels        = var.labels
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


resource "google_sql_database" "database" {
  name     = var.db_name_prefix
  project  = var.project_id
  instance = google_sql_database_instance.sqlinstance.name
}

resource "google_sql_database_instance" "sqlinstance" {

  name                = var.db_name_prefix
  project             = var.project_id
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection
  depends_on          = [google_service_networking_connection.mygcp_vpc_connection]

  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.mygcpnet.id
    }
  }
}

resource "google_sql_user" "sqluser" {
  name       = var.user_name
  project    = var.project_id
  instance   = google_sql_database_instance.sqlinstance.name
  password   = var.user_password
  depends_on = [google_sql_database_instance.sqlinstance]
}
