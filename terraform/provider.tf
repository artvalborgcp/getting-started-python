
terraform {
  required_version = ">=0.15.4"
  required_providers {
    google = ">= 3.43, <4.0"
  }
}
provider "google" {
  #  credentials = "${file("account.json")}"
  project = var.project_id
  region  = var.region
}
