## Allow to list metadata under secret/
## so that UI displays the list of base secret
## User will not be allow to deeper that one level
path "${team}/*" {
  capabilities = ["list", "read"]
}