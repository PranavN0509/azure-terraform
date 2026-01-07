locals {
  domain_name = data.azuread_domains.aad.domains.0.domain_name
  users       = csvdecode(file("users.csv"))
}