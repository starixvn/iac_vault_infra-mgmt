path "nexops/" {
  capabilities = ["read"]
}

path "nexops/metadata" {
  capabilities = ["list"]
}

path "nexops/data/certs" {
  capabilities = ["read", "list"]
}

path "nexops/metadata/certs" {
  capabilities = ["list"]
}

path "nexops/data/certs/*" {
  capabilities = ["read", "update", "patch", "list"]
}
