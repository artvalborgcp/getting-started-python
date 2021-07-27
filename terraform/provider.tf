terraform {
  required_version = ">=0.15.4"
  required_providers {
    google = ">= 3.43, <4.0"
  }
}
provider "google" {
  credentials = file(var.gcp_auth_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  credentials = file(var.gcp_auth_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
