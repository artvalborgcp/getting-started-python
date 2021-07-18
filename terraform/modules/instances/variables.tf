variable "project_id" {
  description = "Project id where service account will be created."
  type        = string
}
variable "region" {
  description = "Region where the instance template should be created."
  type        = string
  default     = null
}
variable "zone" {
  description = "Zone where the instances should be created. If not specified, instances will be spread across available zones in the region."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  type        = string
  default     = "default-instance-template"
}

variable "databackend" {
  description = "Metadata Databackend for the instance template"
  type        = string
  default     = "datastore"
}


variable "machine_type" {
  description = "Machine type to create, e.g. f1-micro"
  type        = string
  default     = "f1-micro"
}

variable "tags" {
  description = "Network tags, provided as a list"
  type        = list(string)
  default     = []
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels, provided as a map"
  type        = map(string)
  default     = {}
}

variable "metadata_startup_script" {
  description = "User startup script to run when instances spin up"
  type        = string
  default     = ""
}


variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  type        = bool
  default     = true
}
variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = ""
}
variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  type        = string
  default     = "pd-standard"
}
variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}
variable "boot" {
  description = "Indicates that this is a boot disk"
  type        = bool
  default     = true
}


variable "check_interval_sec_instance" {
  description = "Check interval for health_check instances"
  type        = number
  default     = 5
}

variable "timeout_sec_instance" {
  description = "Timeout for health_check instances"
  type        = number
  default     = 5
}

variable "healthy_threshold_instance" {
  description = "healthy_threshold for health_check instances"
  type        = number
  default     = 2
}

variable "unhealthy_threshold_instance" {
  description = "healthy_threshold for health_check instances"
  type        = number
  default     = 10
}

variable "target_size" {
  description = "The number of running instances"
  type        = number
  default     = 1
}
variable "initial_delay_sec" {
  description = "Initial Time out before running instances"
  type        = number
  default     = 400
}

variable "url_map" {
  description = "The url for healthcheck"
  type        = string
  default     = "/_ah/health"
}

variable "service_port" {
  description = "Port the service is listening on."
  type        = number
}

variable "service_port_name" {
  description = "Name of the port the service is listening on."
  type        = string
}
variable "account_id" {
  description = "The service account for compute instance id"
  type        = string
}

variable "sa_compute_scope" {
  description = "A list of service scopes. To allow full access to all Cloud APIs, use the cloud-platform "
  type        = list(string)
  default     = []
}

variable "db_name_prefix" {
  description = "The name of the database"
  type        = string
  default     = ""
}

variable "user_name" {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}