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

module "lb" {
  source               = "./modules/lb"
  project_id           = var.project_id
  region               = var.region
  zone                 = var.zone
  name_prefix          = var.name_prefix
  account_id           = var.account_id
  globalforwardingport = var.globalforwardingport
  service_port         = var.service_port
  service_port_name    = var.service_port_name
}



