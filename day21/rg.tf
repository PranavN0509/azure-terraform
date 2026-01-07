resource "azurerm_resource_group" "rg" {
  name = "day21-rg"
  location = "canadacentral"



  depends_on = [ azurerm_policy_definition.policy_tag, azurerm_subscription_policy_assignment.example ]

}