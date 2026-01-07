variable "project_name" {
  type = string
  description = "Name of the project"
  default = "Project ALPHA Resource"
}


variable "default_tags" {
  type = map(string)
  default = {
    company = "CloudOps"
    managed_by = "terraform"
  }
}


variable "environment_tags" {
  type = map(string)
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}


variable "storage_account_name" {
  type = string
  default = "techtutorIALS 1169898689689667565674"
}

variable "allowed_ports" {
  type = string
  default = "80,443,3386"
  description = "List of allowed port numbers"
}

