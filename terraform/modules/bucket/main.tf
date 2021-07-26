resource "google_storage_bucket" "bucket" {
  name          = "${var.project_id}-bucket"
  project       = var.project_id
  labels        = var.labels
  storage_class = var.storage_class
  location      = var.location

}
