

variable "project_id" {
  description = "The ID of the project to create the bucket in."
  type        = string
}

variable "account_id" {
  description = "The service account for compute instance id"
  type        = string
}

variable "roles_for_gcp" {
  description = "Roles for Service Account the Instances"
  type        = map(string)
  default = {
    "storage"   = "roles/storage.objectCreator"
    "datastore" = "roles/datastore.user"
    "pubsub"    = "roles/pubsub.editor"
    "source"    = "roles/source.reader"
    "cloudsql"  = "roles/cloudsql.client"

  }
}

variable "sa_compute_scope" {
  description = "A list of service scopes. To allow full access to all Cloud APIs, use the cloud-platform "
  type        = list(string)
  default     = []
}
