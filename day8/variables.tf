# input variable
variable "environment" {
  type        = string
  default     = "staging"
  description = "This is the environment varibale"
}

variable "storage_disk" {
  type = number
  default = 80
  description = "The storage disk size of the os"
}

variable "is_delete" {
  type = bool
  default = true
  description = "The default behavior to os disk upon vm termination"
}

variable "allowed_locations" {
  type = list(string)
  description = "List of allowed locations"
  default = [ "West Europe", "North Europe", "East US" ]
}


variable "resource_tags" {
  type = map(string)
  description = "tags to apply to the resources"
  default = {
    "environment" = "staging"
    "managed_by" = "terraform"
    "department" = "devops"
  }
}


variable "network_config" {
  type = tuple([ string, string, string ])
  description = "Network Configuration (VNET Address, subnet address, subnet mask)"
  default = [ "10.0.0.0/16", "10.0.2.0", 24]
}


variable "allowed_vm_sizes" {
  type = list(string)
  description = "Allowed VM Sizes"
  default = ["Standard_DS1_v2", "Standard_DS2_v2", "Standard_DS3_v2"]
}

# Object type
variable "vm_config" {
  type = object({
    size         = string
    publisher    = string
    offer        = string
    sku          = string
    version      = string
  })
  description = "Virtual machine configuration"
  default = {
    size         = "Standard_DS1_v2"
    publisher    = "Canonical"
    offer        = "0001-com-ubuntu-server-jammy"
    sku          = "22_04-lts"
    version      = "latest"
  }
}


variable "storage_account_name" {
  type = set(string)
  default = ["techtutorials11", "techtutorials12"]
  description = "storage account names"
}