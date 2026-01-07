output "domain" {
  value = local.domain_name
}

output "username" {
  value = [for user in local.users : "${user.first_name}  ${user.last_name}"]
}