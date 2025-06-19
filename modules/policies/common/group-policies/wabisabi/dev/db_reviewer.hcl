path "pontus/" {
  capabilities = ["read"]
}

path "pontus/data/database/alias" {
  capabilities = ["read", "list"]
}

path "pontus/data/database/credentials" {
  capabilities = ["read", "list"]
}

path "sys/policies/acl/p-mssql-wabi" {
  capabilities = ["read", "list"]
}
