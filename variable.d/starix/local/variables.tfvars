################ CONSTANT VARIABLE ###############
# gitlab_domain               = "gitlab.nexdev.net"
env           = "local"
vault_address = "https://vault.nexdev.net"

CIDR_OFFICE                 = ["10.0.0.0/8"]
application_aws_assume_role = "arn:aws:iam::584102114761:role/lumi-local-vault-role-v1" #required

# 3118: https://gitlab.nexdev.net/iac/vault/infra-mgmt
bound_gitlab_project_id = "3118"
bound_gitlab_ref        = "main,dev,aws,local,deploy_aws_*,deploy_*_local"
bound_gitlab_ref_type   = "branch,tag"
# bound_gitlab_ref        = "*"

#######
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
  {
    policy_name     = "cert-reader",
    policy_path     = "tools",
    policy_template = "cert-reader",
  },
  {
    policy_name     = "cert-updater",
    policy_path     = "tools",
    policy_template = "cert-updater",
  },
  {
    policy_name     = "aws-local-cert-challenger",
    policy_path     = "tools",
    policy_template = "aws-local-cert-challenger",
  },

]
########### ROLE for System/App
roles = [
  {
    role_name       = "dev-admin",
    policy_path     = "dba/local",
    policy_template = "dev-admin",
    # bound_cidrs = [
    #   "10.17.200.0/24",
    #   "10.18.200.0/24",
    #   "10.19.10.0/24"
    # ]
  },
  {
    role_name       = "nexops-sample",
    policy_path     = "tools",
    policy_template = "prometheus-policy",
    # bound_cidrs = [
    #   "10.17.200.0/24",
    #   "10.18.200.0/24",
    #   "10.19.10.0/24"
    # ]
  }

]


########### AUTH ROLE for Kubernetes auth method ############
kube_auth_backends = [
  {
    path = "kubernetes"
    roles = [
      {
        role_name    = "vault-snapshot"
        sa_name      = ["vault-snapshot", ]
        sa_namespace = ["vault", ]
        policies     = ["raft-snapshot", ]
      },
      {
        role_name    = "cert-reader"
        sa_name      = ["vault-cert-injector", ]
        sa_namespace = ["haproxy-ingress", ]
        policies     = ["cert-reader", ]
      },
      {
        role_name    = "cert-updater"
        sa_name      = ["cert-updater-starix-nexprod", ]
        sa_namespace = ["cert-manager", ]
        policies     = ["cert-updater", ]
      },
      {
        role_name    = "aws-local-cert-challenger"
        sa_name      = ["cert-manager-starix-nexprod", ]
        sa_namespace = ["cert-manager", ]
        policies     = ["aws-local-cert-challenger", ]
      },
    ]
  },
  {
    path = "kubernetes-st-backup"
    roles = [
      {
        role_name    = "cert-reader"
        sa_name      = ["vault-cert-injector", ]
        sa_namespace = ["haproxy-ingress", ]
        policies     = ["cert-reader", ]
      },
    ]
  },
  {
    path = "kubernetes-st-local"
    roles = [
      {
        role_name    = "cert-reader"
        sa_name      = ["vault-cert-injector", ]
        sa_namespace = ["haproxy-ingress", ]
        policies     = ["cert-reader", ]
      },
    ]
  },
  {
    path = "kubernetes-sc-local"
    roles = [
      {
        role_name    = "cert-reader"
        sa_name      = ["vault-cert-injector", ]
        sa_namespace = ["haproxy-ingress", ]
        policies     = ["cert-reader", ]
      },
    ]
  },
  {
    path = "kubernetes-sc-lumprod"
    roles = [
      {
        role_name    = "cert-reader"
        sa_name      = ["vault-cert-injector", ]
        sa_namespace = ["haproxy-ingress", ]
        policies     = ["cert-reader", ]
      },
    ]
  },
]


########### AWS role base access management ############
aws_secret_backend = [
  # {
  #   backend = "aws_local"
  #   roles = [
  #     {
  #       name                 = "route53-dns-challenge"
  #       credential_type      = "assumed_role"
  #       policy_document_file = "dns-challenge-lumigame-com.json"
  #     }
  #   ]
  # },
]

########### Gitlab Pipeline Access Control ############
gitlab_pipeline_roles = [
  {
    name              = "aws-general"
    project_ids       = ["3061"] #https://gitlab.nexdev.net/iac/eac
    allowed_branches  = ["*"]
    allowed_ref_types = ["branch", "tag"]
    token_policies    = []
    token_ttl         = 900
  },
  {
    name              = "rancher-access-mgmt"
    project_ids       = ["3155"] #https://gitlab.nexdev.net/iac/rancher/access-mgmt
    allowed_branches  = ["main", "deploy_rancher_access-mgmt_*"]
    allowed_ref_types = ["branch", "tag"]
    token_policies    = []
    token_ttl         = 900
    # Additional paths for specific needs
    additional_paths = [
      {
        path         = "nexops/data/automation/rancher/*"
        capabilities = ["read"]
      },
    ]
  },
  {
    name              = "kubernetes-argo-app"
    project_ids       = ["3157"] #https://gitlab.nexdev.net/iac/kubernetes/argo-app
    allowed_branches  = ["main", "deploy_kubernetes_argo-app_*"]
    allowed_ref_types = ["branch", "tag"]
    token_policies    = []
    token_ttl         = 900
    # Additional paths for specific needs
    additional_paths = [
      {
        path         = "nexops/data/automation/Kubernetes/argo-app/*"
        capabilities = ["read"]
      },
    ]
  },
  {
    name              = "opensearch-datastream-mgmt"
    project_ids       = ["3156"] #https://gitlab.nexdev.net/iac/opensearch
    allowed_branches  = ["main", "deploy_opensearch_datastream-management_*"]
    allowed_ref_types = ["branch", "tag"]
    token_policies    = []
    token_ttl         = 900
    # Additional paths for specific needs
    additional_paths = [
      {
        path         = "nexops/data/automation/Opensearch/datastream-management/*"
        capabilities = ["read"]
      },
    ]
  },
  {
    name              = "opensearch-detection-response"
    project_ids       = ["3282"] #https://gitlab.nexdev.net/iac/opensearch/detection-response
    allowed_branches  = ["main", "deploy_opensearch_detection-response_*"]
    allowed_ref_types = ["branch", "tag"]
    token_policies    = []
    token_ttl         = 900
    # Additional paths for specific needs
    additional_paths = [
      {
        path         = "nexops/data/automation/Opensearch/detection-response/*"
        capabilities = ["read"]
      },
    ]
  },
  {
    name              = "aws-cloudfront-s3-cdn"
    project_ids       = ["3508"] #https://gitlab.nexdev.net/iac/AWS/cloudfront-s3-cdn
    allowed_branches  = ["main", "deploy_aws_cloudfront-s3-cdn_*"]
    allowed_ref_types = ["branch", "tag"]
    token_policies    = []
    token_ttl         = 900
    # Additional paths for specific needs
    additional_paths = []
  },
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
        capabilities = ["read"]
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

####################################
vault_team = [
  {
    name = "nexops",
  },
  {
    name              = "itnw",
    ex_admin_policies = ["cert_updater", ]
    # ex_ro_policies = "",
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
###
vault_admin_users = [
  "troy.vo",
  "ken.nguyen",
  "josh.tran",
  "dennis.le",
]
### ALL Vault Users
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
  #### ITNW
  {
    name = "rio.dang",
    team = "itnw",
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
  {
    name = "nexops.test",
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
      address              = "logstash.nexdev.net:30064"
      socket_type          = "tcp"
      elide_list_responses = "true"
      description          = "logstash socket"
    }
  }
]

