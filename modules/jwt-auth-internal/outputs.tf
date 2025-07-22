# output "auth_backend_path" {
#   description = "The path of the JWT auth backend"
#   value       = vault_jwt_auth_backend.gitlab.path
# }

# output "role_names" {
#   description = "Map of created role names"
#   value       = { for k, v in vault_jwt_auth_backend_role.pipeline_roles : k => v.role_name }
# }

# output "policy_names" {
#   description = "Map of created policy names"
#   value       = { for k, v in vault_policy.pipeline_policies : k => v.name }
# }

# output "auth_mount_accessor" {
#   description = "The mount accessor for the JWT auth backend"
#   value       = vault_jwt_auth_backend.gitlab.accessor
# }
