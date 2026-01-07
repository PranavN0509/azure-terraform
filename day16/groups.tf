resource "azuread_group" "engineering" {
  display_name = "Engineering Department"
  security_enabled = true


  depends_on = [ azuread_user.users ]

}

resource "azuread_group_member" "education" {
    for_each = {for u in azuread_user.users: u.mail_nickname => u if u.department == "Engineering"}
    group_object_id = azuread_group.engineering.object_id
    member_object_id = each.value.object_id

    depends_on = [ azuread_user.users ]
}



resource "azuread_group" "HR" {
  display_name = "HR Department"
  security_enabled = true

}


resource "azuread_group_member" "HR" {
    for_each = {for u in azuread_user.users: u.mail_nickname => u if u.department == "HR"}
    group_object_id = azuread_group.HR.object_id
    member_object_id = each.value.object_id

    depends_on = [ azuread_user.users ]
}


resource "azuread_group" "Finance" {
  display_name = "Finance Department"
  security_enabled = true

}



resource "azuread_group_member" "Finance" {
    for_each = {for u in azuread_user.users: u.mail_nickname => u if u.department == "Finance"}
    group_object_id = azuread_group.Finance.object_id
    member_object_id = each.value.object_id

    depends_on = [ azuread_user.users ]
}
