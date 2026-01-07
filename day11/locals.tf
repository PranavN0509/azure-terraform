locals {
  formatted_name                 = lower(replace(var.project_name, " ", "-"))
  merge_tags                     = merge(var.default_tags, var.environment_tags)
  storage_account_name_formatted = replace(lower(substr(var.storage_account_name, 0, 23)), " ", "")
  formatted_ports                = split(",", (var.allowed_ports))
  nsg_rules = [for port in local.formatted_ports : {
        name = "port-${port}"
        port = port
        description = "Allowed Traffic on port: ${port}"
    }
  ]
}
