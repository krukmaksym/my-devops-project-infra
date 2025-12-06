config {
  call_module_type = "none"
  force            = false
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_unused_declarations" {
  enabled = false
}