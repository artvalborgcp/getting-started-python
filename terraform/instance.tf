resource "google_compute_instance_template" "tpl" {
  name                    = var.name_prefix
  project                 = var.project_id
  machine_type            = var.machine_type
  region                  = var.region
  tags                    = var.tags
  can_ip_forward          = var.can_ip_forward
  labels                  = var.labels
  metadata_startup_script = file(var.metadata_startup_script)

  disk {
    source_image = var.source_image
    auto_delete  = var.auto_delete
    disk_size_gb = var.disk_size_gb
    boot         = true
  }

  network_interface {
    network    = "mygcpnet"
    subnetwork = "mygcpsubnet"
    access_config {
    }
  }




  service_account {

    email  = google_service_account.isa.email
    scopes = ["cloud-platform"]
  }

}

resource "google_compute_instance_from_template" "tpl" {
  name                     = var.name_prefix
  zone                     = var.zone
  source_instance_template = google_compute_instance_template.tpl.id
  network_interface {
    network    = "mygcpnet"
    subnetwork = "mygcpsubnet"
    access_config {
    }
  }
  depends_on = [google_compute_subnetwork.mygcpsubnet]
}
resource "google_storage_bucket" "bucket" {
  name          = "my-gcp-terraform-bucket"
  project       = var.project_id
  labels        = var.labels
  storage_class = var.storage_class
  location      = var.location

}
