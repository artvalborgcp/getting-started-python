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

variable "labels" {
  description = "Labels, provided as a map"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Name prefix of the application "
  type        = string
  default     = "default-application"
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

