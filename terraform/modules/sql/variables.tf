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
  default     = "app"
}

variable "tier" {
  description = "Machine type to create, e.g. f1-micro"
  type        = string
  default     = "db-n1-standard-2"
}
variable "database_version" {
  description = "The MySQL, PostgreSQL or SQL Server (beta) version to use."
  type        = string
  default     = "MYSQL_5_7"
}
variable "deletion_protection" {
  description = "Unless this field is set to false command that deletes the instance will fail"
  type        = bool
  default     = false
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
