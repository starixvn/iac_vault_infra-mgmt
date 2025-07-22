variable "auth_backend_path" {
  description = "Authentication Backend Path that'll hold all role for this JWT auth"
  type        = string
}

variable "gitlab_domain" {
  description = "GitLab domain for JWT issuer"
  type        = string
}

variable "jwt_validation_pubkeys" {
  description = "List of public keys for JWT validation"
  type        = list(string)
}

variable "pipeline_roles" {
  description = "Configuration for different pipeline roles"
  type = list(object({
    name              = string
    project_ids       = list(string)
    allowed_branches  = list(string)
    allowed_ref_types = list(string)
    token_policies    = list(string)
    token_ttl         = number
    # New policy customization fields
    custom_policy_content = optional(string, "")
    additional_paths = optional(list(object({
      path         = string
      capabilities = list(string)
    })), [])
  }))
  default = []
}

variable "default_token_ttl" {
  description = "Default token TTL for JWT auth backend"
  type        = string
  default     = "1h"
}

variable "max_token_ttl" {
  description = "Maximum token TTL for JWT auth backend"
  type        = string
  default     = "24h"
}

variable "policy_template_file" {
  description = "Path to custom policy template file. If not provided, will use the default template"
  type        = string
  default     = "templates/pipeline-policy.hcl.tpl"
}
