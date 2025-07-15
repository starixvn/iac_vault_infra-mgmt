path "pontus/" {
  capabilities = ["read"]
}

path "pontus/data/database/alias" {
  capabilities = ["read", "list"]
}

# path "pontus/metadata/database/credentials" {
#   capabilities = ["list"]
# }

path "sys/policies/acl/p-mssql-wabi" {
  capabilities = ["read", "list"]
}
