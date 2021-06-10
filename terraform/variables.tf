variable "project_id" {
  description = "Project id where service account will be created."
  type        = string
}

variable "machine_type" {
  description = "Machine type to create, e.g. f1-micro"
  default     = "f1-micro"
}

variable "tags" {
  description = "Network tags, provided as a list"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "Region where the instance template should be created."
  type        = string
  default     = null
}

variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  default     = "10"
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = "true"
}

variable "metadata_startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "labels" {
  description = "Labels, provided as a map"
  type        = map(string)
  default     = {}
}

variable "storage_class" {
  description = "Storage bucket class."
  type        = string
  default     = "STANDARD"
}
variable "location" {
  description = "GCS location for storage bucket"
  type        = string
  default     = "US"
}
