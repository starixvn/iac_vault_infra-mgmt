path "nexops/" {
  capabilities = ["read"]
}

path "nexops/data/certs" {
  capabilities = ["read", "list"]
}

path "nexops/data/certs/*" {
  capabilities = ["read", "update", "patch", "list"]
}
