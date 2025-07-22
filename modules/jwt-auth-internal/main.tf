# JWT Auth Backend Configuration
resource "vault_jwt_auth_backend" "gitlab" {
  description            = "JWT auth backend for GitLab-CI pipelines"
  path                   = var.auth_backend_path
  bound_issuer           = var.gitlab_domain
  jwt_validation_pubkeys = var.jwt_validation_pubkeys
  # jwks_url               = "https://${var.gitlab_domain}/-/jwks"

  tune {
    default_lease_ttl = var.default_token_ttl
    max_lease_ttl     = var.max_token_ttl
    token_type        = "default-service"
  }
}

# Dynamic JWT Auth Roles
resource "vault_jwt_auth_backend_role" "pipeline_roles" {
  for_each       = { for role in var.pipeline_roles : role.name => role }
  backend        = vault_jwt_auth_backend.gitlab.path
  role_type      = "jwt"
  role_name      = each.key
  token_policies = concat(each.value.token_policies, [vault_policy.pipeline_policies[each.key].name])
  token_ttl      = each.value.token_ttl

  bound_claims = {
    project_id = join(",", each.value.project_ids)
    ref        = join(",", each.value.allowed_branches)
    ref_type   = join(",", each.value.allowed_ref_types)
  }

  user_claim = "user_email"
}

# Create policy documents for each role using template
resource "vault_policy" "pipeline_policies" {
  for_each = { for role in var.pipeline_roles : role.name => role }
  name     = "m-jwt-auth/${each.key}"

  policy = templatefile("${path.module}/${var.policy_template_file}", {
    role_name             = each.key
    custom_policy_content = each.value.custom_policy_content
    additional_paths      = each.value.additional_paths
  })
}
