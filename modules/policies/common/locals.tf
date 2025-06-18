locals {
  ex_admin_policies = flatten([
    for team in var.vault_team :
    length(lookup(team, "ex_admin_policies", [])) > 0 ? [
      for policy in team.ex_admin_policies : {
        team_name   = "${team.name}"
        policy_name = "${team.name}/${policy}"
        policy_path = "${path.module}/group-policies/${team.name}/${var.env}/${policy}.hcl"
        policy_id   = "${team.name}-${policy}"
      }
    ] : []
  ])

  policy_group_for_team = flatten([
    for team in var.vault_team : {
      team_name = "${team.name}"
      policies = concat(
        ["${team.name}/admin"],
        [for policy in team.ex_admin_policies : "${team.name}/${policy}"]
      )
    }
  ])
}
