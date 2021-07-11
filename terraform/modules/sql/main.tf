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

  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/${var.name_prefix}"
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
