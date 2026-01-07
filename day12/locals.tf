locals {
  formatted_name                 = lower(replace(var.project_name, " ", "-"))
  merge_tags                     = merge(var.default_tags, var.environment_tags)
  storage_account_name_formatted = replace(lower(substr(var.storage_account_name, 0, 23)), " ", "")
  formatted_ports                = split(",", (var.allowed_ports))
  nsg_rules = [for port in local.formatted_ports : {
    name        = "port-${port}"
    port        = port
    description = "Allowed Traffic on port: ${port}"
    }
  ]
  vm_size          = lookup(var.vm_sizes, var.environment, lower("dev"))
  user_locations   = ["eastus", "westus", "eastus"]
  default_location = ["centralus"]
  unique_locations = toset(concat(local.user_locations, local.default_location))

  #assignment 10
  monthly_costs  = [-50, 100, 75, 200]
  positive_costs = [for cost in local.monthly_costs : abs(cost)]
  max_cost       = max(local.positive_costs...)


  # assignment 11
  current_time  = timestamp()
  resource_name = formatdate("YYYYMMDD", local.current_time)
  tag_date      = formatdate("DD-MM-YY", local.current_time)


  # assignment 12
  config_content = sensitive(file("config.json"))


}
