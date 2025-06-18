
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "readonly" {
  for_each = { for entry in var.vault_team : "${entry.name}" => entry }
  name     = "${each.key}/readonly"
  policy = templatefile("${path.module}/group-policies/default/readonly.hcl.tpl", {
    team = "${each.key}"
  })
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "admin" {
  for_each = { for entry in var.vault_team : "${entry.name}" => entry }
  name     = "${each.key}/admin"
  policy = templatefile("${path.module}/group-policies/default/admin.hcl.tpl", {
    team = "${each.key}"
  })
}

resource "vault_policy" "ex_admin_policies" {
  for_each = { for entry in local.ex_admin_policies : "${entry.policy_id}" => entry }
  name     = each.value.policy_name
  policy   = file(each.value.policy_path)
}


# resource "vault_policy" "ex_admin_policy" {
#   for_each = { for entry in var.vault_team : "${entry.name"}
# }
