# Example implementation of the enhanced JWT authentication module
module "gitlab_jwt_auth" {
  source                 = "./modules/jwt-auth-internal"
  auth_backend_path      = var.gitlab_pipeline_jwt_auth_backend
  gitlab_domain          = var.gitlab_domain
  jwt_validation_pubkeys = var.jwk_gitlab_nexdev
  default_token_ttl      = "15m"
  max_token_ttl          = "1h"
  pipeline_roles         = var.gitlab_pipeline_roles
}
