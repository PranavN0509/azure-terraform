variable "location" {
  type = list(string)
  description = "Allowed locations"
  default = [ "eastus", "westus" ]
}


variable "vm_sizes" {
  type = list(string)
  description = "Allowed VM sizes"
  default = [ "Standard_B2s", "Standard_B2ms" ]
}


variable "allowed_tags" {
  type = list(string)
  description = "value"
  default = [ "department", "project" ]
}


variable "subscription_id" {
  type = string
  description = "The subscription id"
}