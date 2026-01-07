variable "location" {
  description = "Location in which aks cluster is to be created"
}

variable "resource_group_name" {
  description = "Resource group name in which aks cluster is to be created"
}

variable "service_principal_name" {
  description = "The service principal name "
  type        = string
}

# variable "ssh_public_key" {
#   default = "~/.ssh/id_rsa.pub"
# }

variable "client_id" {
  description = "The client id of the service principal created"
}
variable "client_secret" {
  description = "The client secret of the service principal created"
  type        = string
  sensitive   = true
}
