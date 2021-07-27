
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

variable "labels" {
  description = "Labels, provided as a map"
  type        = map(string)
  default     = {}
}

variable "account_id" {
  description = "The service account for compute instance id"
  type        = string
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


