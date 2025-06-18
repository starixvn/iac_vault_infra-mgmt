

//add policies that are the same for every environment
module "env_policies" {
  source     = "./modules/policies/common"
  env        = var.env
  vault_team = var.vault_team
}
