variable "gcp_auth_file" {
  description = "GCP authentication file"
  type        = string
}

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
  description = "Databackend for the instance template"
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
  default     = "false"
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
  default     = "true"
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


variable "auto_create_subnetworks" {
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  type        = bool
  default     = false
}


variable "ip_cidr_range" {
  description = "The ip subnet of the network being created"
  type        = string
}

variable "firewallallowports" {
  description = "Firewall Ports, provided as a list"
  type        = list(string)
  default     = []
}
variable "firewallallowproto" {
  description = "Firewall Protocols, provided as a list"
  type        = string
}

variable "nat_ip_allocate_option" {
  description = "How external IPs should be allocated for this NAT."
  type        = string
  default     = "AUTO_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "How NAT should be configured per Subnetwork"
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
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

variable "globalforwardingport" {
  description = "Port forward"
  type        = number
}

variable "timeout_backendservice" {
  description = "Timeout health check for backendservice"
  type        = number
  default     = 10
}
variable "protocol_backendservice" {
  description = "Protocol health check for backendservice"
  type        = string
  default     = "HTTP"
}


variable "timeout_mygcplb" {
  description = "Timeout health check for load balancer"
  type        = number
  default     = 1
}

variable "check_interval_mygcplb" {
  description = "Check interval health check for load balancer"
  type        = number
  default     = 1
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


variable "roles_for_gcp" {
  description = "Roles for Service Account the Instances"
  type        = map(string)
  default = {
    "storage"   = "roles/storage.objectCreator"
    "datastore" = "roles/datastore.user"
    "pubsub"    = "roles/pubsub.editor"
    "source"    = "roles/source.reader"

  }
}
