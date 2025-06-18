
/*** DEV ENV ***/
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
# resource "vault_identity_group" "env_admin" {
#   for_each                   = { for entry in var.vault_team : "${entry.name}" => entry }
#   name                       = "${each.key}/admin"
#   type                       = "internal"
#   policies                   = ["${each.key}/admin"]
#   external_member_entity_ids = true
# }

resource "vault_identity_group" "env_admin" {
  for_each                   = { for entry in local.policy_group_for_team : "${entry.team_name}" => entry }
  name                       = "${each.key}/admin"
  type                       = "internal"
  policies                   = each.value.policies
  external_member_entity_ids = true
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "env_readonly" {
  for_each                   = { for entry in var.vault_team : "${entry.name}" => entry }
  name                       = "${each.key}/readonly"
  type                       = "internal"
  policies                   = ["${each.key}/readonly"]
  external_member_entity_ids = true
}
