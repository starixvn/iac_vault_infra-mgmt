env           = "uat"
vault_address = "https://vault-st-klu.starixuat.com"

application_aws_assume_role = "arn:aws:iam::584102114761:role/lumi-prod-vault-role-v1"

# 3118: https://gitlab.nexdev.net/iac/vault/infra-mgmt
bound_gitlab_project_id = "3118"
bound_gitlab_ref        = "main,dev,uat,deploy_*_uat"
bound_gitlab_ref_type   = "branch,tag"

##########
########### mount
vault_mount = [
  {
    path = "nexops",
    type = "kv-v2"
  },
  {
    path = "pontus",
    type = "kv-v2"
  },
  {
    path = "rome",
    type = "kv-v2"
  },
  {
    path = "olympus",
    type = "kv-v2"
  },
  {
    path = "nexus",
    type = "kv-v2"
  },

]
########### Policy
polices = [
  ## Users / Team
  ############## System/App

  ############## Automation / Tools
  {
    policy_name     = "prometheus",
    policy_path     = "tools",
    policy_template = "prometheus-policy",
  },
  {
    policy_name     = "raft-snapshot",
    policy_path     = "tools",
    policy_template = "raft-snapshot",
  },

]
########### ROLE for System/App
roles = []

########### AUTH ROLE for Kubernetes auth method ############
kubernetes_auth_role = [
  {
    role_name    = "vault-snapshot",
    sa_name      = "vault-snapshot",
    sa_namespace = "vault",
    policies     = ["raft-snapshot", ],
  },
]

kube_auth_backends = [
  {
    path = "kubernetes",
    roles = [
      {
        role_name    = "vault-snapshot"
        sa_name      = ["vault-snapshot", ]
        sa_namespace = ["vault", ]
        policies     = ["raft-snapshot", ]
      },
    ]
  },
]

########### Gitlab Pipeline Access Control ############
gitlab_pipeline_roles = [
  {
    name              = "vault-dba-policy-mgmt"
    project_ids       = ["3117"] #https://gitlab.nexdev.net/iac/vault/dba-policy-mgmt
    allowed_branches  = ["main", "deploy_vault_dba-policy-mgmt_*"]
    allowed_ref_types = ["branch", "tag"]
    token_policies    = []
    token_ttl         = 900
    additional_paths = [
      {
        path         = "sys/auth"
        capabilities = ["list"]
      },
      {
        path         = "sys/auth/approle"
        capabilities = ["read", "create", "update", "delete"]
      },
      {
        path         = "auth/approle/role/*"
        capabilities = ["read", "list", "create", "update", "delete"]
      },
      {
        path         = "sys/policies/acl/p-mssql-*"
        capabilities = ["read", "create", "update", "delete"]
      },
      {
        path         = "identity/entity/id/*"
        capabilities = ["read", "create", "update", "delete"]
      },
      {
        path         = "/identity/entity-alias/id/*"
        capabilities = ["create", "update", "read", "delete"]
      },
    ]
  },
]

#####################################
vault_team = [
  {
    name = "nexops",
  },
  {
    name = "pontus",
  },
  {
    name = "rome",
  },
  {
    name = "olympus",
  },
  {
    name = "nexus",
  },
  {
    name = "legion",
  },
]

## Vault Admin Users
##
vault_admin_users = [
  "troy.vo",
  "ken.nguyen",
  "josh.tran",
  "dennis.le",
]
## ALL Vault Users
vault_users = [
  {
    name = "troy.vo",
    team = "nexops",
  },
  {
    name = "ken.nguyen",
    team = "nexops",
  },
  {
    name = "dennis.le",
    team = "nexops",
  },
  {
    name = "josh.tran",
    team = "nexops",
  },
  #### DBA
  {
    name = "lukas.luu",
    team = "pontus",
  },
  {
    name = "patrick.pham",
    team = "pontus",
  },
  {
    name = "sol.le",
    team = "pontus",
  },
  {
    name = "brice.nguyen",
    team = "pontus",
  },
  {
    name = "evan.trinh",
    team = "pontus",
  },
  {
    name = "daniel.truong",
    team = "pontus",
  },
  {
    name = "dominic.dao",
    team = "pontus",
  },
  #### DEV
  {
    name = "jacob.phan",
    team = "olympus",
  },
  {
    name = "ethan.nguyen",
    team = "rome",
  },
  {
    name = "kos.nguyen",
    team = "legion",
  },
]

vault_users_readonly = []

############### Demo 
vault_generic_secret = []

################ AUDIT DEVICE ################
audit_devices = [
  {
    type = "file"
    options = {
      file_path = "stdout"
    }
  },
  {
    type = "socket"
    options = {
      address              = "logstash-starix-k3suat-logstash.logging.svc:5064"
      socket_type          = "tcp"
      elide_list_responses = "true"
      description          = "logstash socket"
    }
  }
]
