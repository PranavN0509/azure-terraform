resource "azuread_user" "users" {
  for_each = { for user in local.users : user.first_name => user }
  user_principal_name = format("%s%s@%s",
    substr(each.value.first_name, 0, 1),
    lower(each.value.last_name),
    local.domain_name
  )

  password = format("%s%s%s!",
    lower(each.value.last_name),
    substr(each.value.first_name, 0, 1),
    length(each.value.first_name)
  )


  display_name          = "${each.value.first_name} ${each.value.last_name}"
  force_password_change = true
  department            = each.value.department
  job_title             = each.value.job_title
}

