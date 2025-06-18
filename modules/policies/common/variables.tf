variable "vault_team" {
  description = "Team Variable used as a prefix"
  type = list(object({
    name              = string
    ex_admin_policies = optional(list(string), [])
    ex_ro_policies    = optional(list(string), [])
  }))
  # default = [{}]
}

variable "env" {
  description = "Environment Variable"
  type        = string
  default     = ""
}
