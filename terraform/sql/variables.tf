

variable "name_db" {
  description = "Name prefix for the sql_instance template"
  type        = string
  default     = "default-instance-template"
}

variable "tier" {
  description = "Machine type to create, e.g. f1-micro"
  default     = "n1-standard"
}
