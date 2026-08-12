# infrastructure/terraform

Infrastructure as code — servers, databases, DNS, storage, secret resources.

**Rule:** `terraform.tfstate` and `*.tfvars` are never committed (they are in
`.gitignore`). State belongs in a remote backend.

No resource should be created by hand — describe everything here.
