# # Token creation
# path "auth/token/create" {
#   capabilities = ["update"]
# }

${custom_policy_content}

# Additional role-specific paths
%{ for path in additional_paths ~}
path "${path.path}" {
  capabilities = ${jsonencode(path.capabilities)}
}
%{ endfor ~}