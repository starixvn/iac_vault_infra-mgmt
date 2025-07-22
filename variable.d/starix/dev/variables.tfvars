env           = "dev"
vault_address = "https://vault-dev.nexdev.net"
region        = "ap-northeast-1"

# 3118: https://gitlab.nexdev.net/iac/vault/infra-mgmt
bound_gitlab_project_id = "3118"
bound_gitlab_ref        = "main,deploy_vault_infra-mgmt_*"
bound_gitlab_ref_type   = "branch,tag"

###########
########### mount
vault_mount = [
  {
    path = "nexops",
    type = "kv-v2",
  },
  {
    path = "pontus",
    type = "kv-v2",
  },
  {
    path = "rome",
    type = "kv-v2",
  },
  {
    path = "olympus",
    type = "kv-v2",
  },
  {
    path = "nexus",
    type = "kv-v2",
  },
  {
    path = "wabisabi",
    type = "kv-v2",
  }
]
########### Policy
polices = [
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
roles = [
  {
    role_name       = "dev-admin",
    policy_path     = "dba/dev",
    policy_template = "dev-admin",
    bound_cidrs = [
      "10.18.200.0/24",
      "10.19.10.0/24"
    ]
  },
]

########### AUTH ROLE for Kubernetes auth method ############
kube_auth_backends = [
  {
    path = "kubernetes",
    roles = [
      {
        role_name    = "vault-snapshot"
        sa_name      = ["vault-snapshot", ]
        sa_namespace = ["vault-dev", ]
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

####################################
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
  {
    name              = "wabisabi",
    ex_admin_policies = ["db_reviewer", ]
    # ex_ro_policies = "",
  },
]

## Vault Admin Users
####
vault_admin_users = [
  "troy.vo",
  "ken.nguyen",
  "josh.tran",
  "jacob.phan",
  "sol.le",
]
## ALL Vault Users
vault_users = [
  {
    name = "wasa.user",
    team = "wabisabi",
  },
  {
    name = "troy.vo",
    team = "nexops",
  },
  {
    name = "ken.nguyen",
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

vault_users_readonly = [
]

############## Demo 
vault_generic_secret = [
  {
    path     = "rome/alpha/api_1",
    username = "alpha1",
    password = "y7changeme",
  },
  {
    path     = "olympus/setle/api_1",
    username = "setle1",
    password = "changeme",
  },
  ###Automation & tools
  {
    path     = "nexops/automation/ansible/apitest",
    username = "ansible",
    password = "changeme",
  },
  {
    path     = "nexops/cloud/aws/apitest",
    username = "aws",
    password = "changeme",
  },

]

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
      address              = "logstash.nexdev.net:30065"
      socket_type          = "tcp"
      elide_list_responses = "true"
      description          = "logstash socket"
    }
  }
]

################ CONSTANT VARIABLE ################
CIDR_OFFICE = ["10.0.0.0/8"]


application_aws_assume_role = "arn:aws:iam::584102114761:role/lumi-local-vault-role-v1" #required
# gitlab_domain               = "https://gitlab.nexdev.net"
