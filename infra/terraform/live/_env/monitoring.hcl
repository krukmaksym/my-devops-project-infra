locals {
  env = basename(dirname(get_terragrunt_dir()))

  monitoring = {
    dev = {
      vm_stack_chart_version = "0.72.4"
      retention_period       = "14d"
    }

    stage = {
      vm_stack_chart_version = "0.72.4"
      retention_period       = "14d"
    }

    prod = {
      vm_stack_chart_version = "0.72.4"
      retention_period       = "30d"
    }
  }
}

inputs = local.monitoring[local.env]
