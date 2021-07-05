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
