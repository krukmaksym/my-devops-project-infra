# my-devops-project-infra

Infrastructure-as-Code project designed to master Senior DevOps / SRE skills:

- Terraform + Terragrunt
- Kubernetes (DigitalOcean DOKS)
- GitOps (ArgoCD)
- CI/CD pipelines
- Observability stack (Prometheus / Grafana / Loki)
- Secrets management with Doppler

The infrastructure is hosted on DigitalOcean and follows production-grade patterns.

## Pre-commit Hooks

This repository uses **pre-commit** to ensure consistent formatting, validation, and security checks for all Terraform and Terragrunt code.

Enabled hooks:
- `terraform_fmt` – formats all Terraform files according to HCL standards  
- `terraform_validate` – validates Terraform configuration  
- `terraform_docs` – automatically generates module documentation  
- `terragrunt_fmt` – formats Terragrunt HCL files  
- `tflint` – lints Terraform code and detects potential issues  
- `tfsec` – static security analysis for Terraform  
- `checkov` – advanced IaC security scanners  
- `yamllint` – validates YAML files (useful for Kubernetes & GitOps manifests)

### Install pre-commit

```bash
brew install pre-commit
pre-commit install
