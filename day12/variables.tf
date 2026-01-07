variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "Project ALPHA Resource"
}


variable "default_tags" {
  type = map(string)
  default = {
    company    = "CloudOps"
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
  type    = string
  default = "techtutorIALS 1169898689689667565674"
}

variable "allowed_ports" {
  type        = string
  default     = "80,443,3386"
  description = "List of allowed port numbers"
}


variable "environment" {
  type        = string
  default = "dev"
  description = "environment name"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Enter the valid value for environment"
  }
}

variable "vm_sizes" {
  type = map(string)
  default = {
    dev     = "standard_D2s_v3",
    staging = "standard_D4s_v3",
    prod    = "standard_D8s_v3"
  }
}



variable "vm_size" {
  type = string
  default = "Standard_D2s_v3"
  validation {
    condition = length(var.vm_size)>=2 && length(var.vm_size)<=20
    error_message = "The vm_size should be between 2 and 20 characters"
  }
  validation {
    condition = strcontains(lower(var.vm_size), "standard")
    error_message = "The VM size should contain standard"
  }
}


variable "backup_name" {
  default = "default_backup"
  type = string
  validation {
    condition = endswith(var.backup_name, "_backup")
    error_message = "Backup should end with _backup"
  }
}

variable "backup_credential" {
  type = string
  default = "xyz123"
  sensitive = true
}

