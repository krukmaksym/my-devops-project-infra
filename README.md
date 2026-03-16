# DevOps Portfolio Infrastructure Project

> A production-grade Infrastructure-as-Code project demonstrating advanced DevOps/SRE practices, built with Terraform, Terragrunt, Kubernetes, and modern cloud-native tooling.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-1.14.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![DigitalOcean](https://img.shields.io/badge/Cloud-DigitalOcean-0080FF?logo=digitalocean)](https://www.digitalocean.com/)

---

## Table of Contents

- [Overview](#overview)
- [Current Architecture](#current-architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Current Implementation Status](#current-implementation-status)
- [Development Roadmap](https://github.com/krukmaksym/my-devops-project-infra/blob/main/DEVELOPMENT.md)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

---


## Documentation

- [Architecture Diagrams](docs/architecture/diagrams.md) - High-level and node-pool specific designs.
- [Troubleshooting Guide](docs/troubleshooting.md) - Common issues and solutions.

## Overview

This project serves as a comprehensive demonstration of Senior DevOps and SRE capabilities, implementing industry best practices for infrastructure automation, cloud-native application deployment, and operational excellence.

### Key Objectives

- Demonstrate proficiency in Infrastructure as Code (IaC)
- Implement production-grade Kubernetes cluster management
- Showcase GitOps workflows and continuous delivery
- Build comprehensive observability and monitoring solutions
- Apply security best practices throughout the infrastructure
- Create reproducible, multi-environment deployments

---

## Current Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                      DigitalOcean Cloud                       │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌───────────────────────────────────────────────────────┐    │
│  │              Environment: dev / stage / prod          │    │
│  │                                                       │    │
│  │  ┌────────────────────────────────────────────────┐   │    │
│  │  │           VPC (10.x.0.0/24)                    │   │    │
│  │  │                                                │   │    │
│  │  │  ┌──────────────────────────────────────────┐  │   │    │
│  │  │  │  Kubernetes Cluster (DOKS 1.35)          │  │   │    │
│  │  │  │                                          │  │   │    │
│  │  │  │  ┌─────────────────────────────────────┐ │  │   │    │
│  │  │  │  │   Application Node Pool             │ │  │   │    │
│  │  │  │  │   - Auto-scaling (2-10 nodes)       │ │  │   │    │
│  │  │  │  │   - No taint (hosts system pods)    │ │  │   │    │
│  │  │  │  └─────────────────────────────────────┘ │  │   │    │
│  │  │  │                                          │  │   │    │
│  │  │  │  ┌─────────────────────────────────────┐ │  │   │    │
│  │  │  │  │   Monitoring Node Pool (s-2vcpu-4gb)│ │  │   │    │
│  │  │  │  │   - Tainted: service=monitoring     │ │  │   │    │
│  │  │  │  │   ┌──────────┐  ┌────────────────┐  │ │  │   │    │
│  │  │  │  │   │ ArgoCD   │  │ VictoriaMetrics│  │ │  │   │    │
│  │  │  │  │   │ (GitOps) │  │ + Grafana      │  │ │  │   │    │
│  │  │  │  │   └──────────┘  └────────────────┘  │ │  │   │    │
│  │  │  │  │        │                            │ │  │   │    │
│  │  │  │  └────────┼────────────────────────────┘ │  │   │    │
│  │  │  └───────────┼──────────────────────────────┘  │   │    │
│  │  └──────────────┼─────────────────────────────────┘   │    │
│  │                 │                                     │    │
│  │  ┌──────────────▼────────┐                            │    │
│  │  │  DO Load Balancer     │                            │    │
│  │  │  (ArgoCD endpoint)    │                            │    │
│  │  └───────────────────────┘                            │    │
│  └───────────────────────────────────────────────────────┘    │
└───────────────────────────────────────────────────────────────┘

          │                                    │
          ▼                                    ▼
    ┌──────────┐                        ┌──────────┐
    │ Doppler  │                        │Terraform │
    │ Secrets  │                        │  Cloud   │
    └──────────┘                        └──────────┘
```

---

## Technology Stack

### Infrastructure & Platform
- **IaC**: Terraform 1.14.0 + Terragrunt 0.93.11 (DRY configuration)
- **Cloud Provider**: DigitalOcean
- **Container Orchestration**: Kubernetes (DOKS) 1.35.1
- **State Management**: Terraform Cloud
- **Secrets Management**: Doppler

### DevOps Tools (Implemented)
- **CI/CD**: GitHub Actions (PR validation, deployment, destroy, AI code review via Claude & Gemini)
- **GitOps**: ArgoCD (bootstrapped via Terraform, GitHub OAuth SSO prepared)
- **Observability**: VictoriaMetrics + Grafana (deployed via Helm)
- **Pre-commit**: terraform-fmt, terragrunt-fmt, tflint, tfsec, trivy, checkov, terraform-docs
- **Security Scanning**: Trivy, Checkov, tfsec (in CI pipeline)

### Planned Stack
- **GitOps**: Migrate workloads from Terraform Helm to ArgoCD Applications
- **Observability**: Loki (logging), Tempo (tracing)
- **Progressive Delivery**: Argo Rollouts (canary, blue-green)
- **Security**: OPA Gatekeeper, Falco runtime security
- **Service Mesh**: Istio/Linkerd (future)
- **Backup**: Velero

---

## Project Structure

```
my-devops-project-infra/
├── .github/
│   ├── actions/                  # Reusable composite actions
│   │   ├── detect-infra-changes/ # Smart change detection for matrix strategy
│   │   ├── setup-terragrunt/     # Install Terraform, Terragrunt, Doppler
│   │   └── terragrunt-exec/      # Execute Terragrunt with Doppler secrets
│   └── workflows/
│       ├── terraform-pr.yml      # PR validation (format, validate, plan, security)
│       ├── terraform-deploy.yml  # Deployment workflow (manual + auto on merge)
│       ├── destroy-infra.yml     # Infrastructure destroy (with safeguards)
│       ├── claude-review.yml     # AI-powered code review
│       └── gemini-review.yml    # Gemini CLI PR review (on @gemini-cli comment)
├── CLAUDE.md                    # Claude code review instructions & guardrails
├── GEMINI.md                    # Gemini code review instructions & guardrails
├── .pre-commit-config.yaml      # Pre-commit hooks configuration
├── docs/                        # Project documentation
│   ├── architecture/            # Architecture diagrams
│   └── troubleshooting.md       # Troubleshooting guide
├── Makefile                     # Automation shortcuts for Terragrunt
├── README.md                    # This file
├── LICENSE                      # MIT License
└── infra/
    └── terraform/
        ├── modules/              # Reusable Terraform modules
        │   ├── network/          # VPC provisioning
        │   ├── kubernetes/       # DOKS cluster + node pools
        │   ├── monitoring/       # VictoriaMetrics observability stack
        │   └── argocd/           # ArgoCD GitOps controller
        └── live/                 # Environment-specific configurations
            ├── root.hcl          # Global Terragrunt config (TF Cloud backend)
            ├── _env/             # Shared environment variable definitions
            │   ├── network.hcl   # Network configs per env
            │   ├── kubernetes.hcl # K8s configs per env
            │   ├── monitoring.hcl # Monitoring configs per env
            │   └── argocd.hcl    # ArgoCD configs per env (phased rollout)
            ├── dev/              # Development environment
            │   ├── network/
            │   ├── kubernetes/
            │   ├── monitoring/
            │   └── argocd/
            ├── stage/            # Staging environment
            │   ├── network/
            │   ├── kubernetes/
            │   ├── monitoring/
            │   └── argocd/
            └── prod/             # Production environment
                ├── network/
                ├── kubernetes/
                ├── monitoring/
                └── argocd/
```

---

## Getting Started

### Prerequisites

```bash
# Required tools
brew install terraform terragrunt doppler pre-commit

# Verify installations
terraform version    # Should be 1.14.0
terragrunt --version
doppler --version
```

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/my-devops-project-infra.git
   cd my-devops-project-infra
   ```

2. **Install pre-commit hooks**
   ```bash
   pre-commit install
   ```

3. **Configure Doppler secrets**
   ```bash
   doppler login
   doppler setup
   # Add required secrets (uppercase in Doppler UI):
   # - DO_TOKEN (DigitalOcean API token - will become TF_VAR_do_token)
   ```

4. **Configure Terraform Cloud**
   - Create organization: `my-devops-project`
   - Workspaces will be auto-created by Terragrunt

5. **Configure GitHub Secrets** (for CI/CD)
   ```bash
   # Repository secrets (Settings > Secrets and variables > Actions):
   # - DOPPLER_TOKEN: Your Doppler service token
   # - TF_CLOUD_TOKEN: Your Terraform Cloud API token
   # - ANTHROPIC_API_KEY: Anthropic API key (for @claude PR reviews)
   # - GEMINI_API_KEY: Google Gemini API key (for @gemini-cli PR reviews)
   ```

6. **Initialize and plan infrastructure**
   ```bash
   # Plan for dev environment
   make plan-dev

   # Apply dev environment
   make run-dev
   ```

---

## Current Implementation Status

### ✅ Implemented

| Component | Description |
|-----------|-------------|
| **Multi-environment setup** | dev, stage, prod with graduated node sizing |
| **Network module** | VPC provisioning with environment-specific CIDR blocks |
| **Kubernetes module** | DOKS 1.35 cluster with app + monitoring node pools, auto-scaling, monitoring pool taint |
| **Monitoring module** | VictoriaMetrics + Grafana deployed via Helm with tolerations, persistent storage |
| **ArgoCD module** | GitOps controller bootstrapped via Terraform Helm, DO LoadBalancer, GitHub OAuth SSO prepared (Dex), team-scoped RBAC |
| **Terragrunt DRY config** | Centralized `_env/` configs, per-module provider generation, mock outputs for CI |
| **Doppler integration** | Secrets injected as `TF_VAR_*` via Doppler CLI |
| **Remote state** | Terraform Cloud backend with per-workspace isolation |
| **CI/CD Pipeline** | 5 GitHub Actions workflows: PR validation, deployment, destroy, AI code review (Claude), Gemini PR review |
| **Pre-commit hooks** | terraform-fmt, terragrunt-fmt, tflint, tfsec, trivy, checkov, terraform-docs |
| **Security scanning** | Trivy + Checkov + tfsec in CI pipeline, Infracost cost estimation |
| **Auto-scaling** | Node pool auto-scaling (2-10 nodes depending on env) |
| **Lifecycle protection** | `prevent_destroy` on critical resources, `create_before_destroy` on node pools |

### 🚧 In Progress / Next Steps

| Component | Priority | Description |
|-----------|----------|-------------|
| **ArgoCD HTTPS** | High | Enable TLS on ArgoCD LoadBalancer (cert-manager or DO-managed certs) |
| **ArgoCD OAuth SSO** | High | Configure GitHub OAuth App, connect Dex, disable admin account |
| **Migrate monitoring to ArgoCD** | Medium | Move VictoriaMetrics from Terraform Helm to ArgoCD Application |
| **Grafana dashboards** | Medium | Custom dashboards for cluster and application metrics |
| **Loki logging** | Medium | Centralized log aggregation |
| **Progressive delivery** | Low | Argo Rollouts for canary/blue-green deployments |
| **Disaster recovery** | Low | Velero backup/restore |

---

## CI/CD Pipeline

### GitHub Actions Workflows

The project includes five GitHub Actions workflows for comprehensive infrastructure management:

#### 1. PR Validation Workflow ([`terraform-pr.yml`](.github/workflows/terraform-pr.yml))

Runs on every pull request to `main` for validation and planning.

#### Workflow Features

1. **Security Gate**: Prevents workflow execution for forked PRs to protect secrets
2. **Smart Change Detection**: Identifies modified Terraform files and builds a matrix of affected environments
3. **Terraform Format Check**: Validates code formatting across all Terraform files
4. **Parallel Validation**: Runs `terragrunt validate` in parallel for all affected env/module combinations
5. **Parallel Planning**: Generates Terraform plans for all changes and posts summaries as PR comments
6. **Summary Report**: Aggregates results from all jobs and provides overall workflow status

#### 2. Deployment Workflow ([`terraform-deploy.yml`](.github/workflows/terraform-deploy.yml))

Automated deployment workflow triggered on push to `main` or manual workflow dispatch.

**Features:**
- Manual deployment with environment selection (dev/stage/prod)
- Resource-specific deployment (network, kubernetes, monitoring, argocd, or all)
- Branch constraints (production deployments only from `main`)
- Doppler secrets integration
- Support for both selective and bulk deployments

#### 3. Infrastructure Destroy Workflow ([`destroy-infra.yml`](.github/workflows/destroy-infra.yml))

Manual workflow for safely destroying infrastructure with safeguards.

**Features:**
- Requires "DESTROY" confirmation text to execute
- Environment selection (dev/stage/prod/all)
- Resource-specific destruction
- Smart network exclusion (prevents "Cannot delete default VPC" error)
- Strict dependency handling with `--queue-strict-include`

#### 4. Claude Code Review Workflow ([`claude-review.yml`](.github/workflows/claude-review.yml))

On-demand AI code review triggered by commenting `@claude` on an open pull request. Uses the [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action) action with project-specific review instructions defined in [`CLAUDE.md`](CLAUDE.md).

**Features:**
- Triggered by `@claude` comment on any open PR (`issue_comment` event)
- Security gate blocks execution for forked PRs to protect secrets
- Reviews the PR diff for security, Terraform/Terragrunt best practices, state management, cost impact, and breaking changes
- Posts review as a sticky PR comment with severity levels (critical, warning, suggestion)
- Uses `ANTHROPIC_API_KEY` secret with scoped tool access (`Bash(gh *)`, `Read`, `Glob`, `Grep`)

#### 5. Gemini Code Review Workflow ([`gemini-review.yml`](.github/workflows/gemini-review.yml))

On-demand AI code review triggered by commenting `@gemini-cli` on an open pull request. Uses the [google-github-actions/run-gemini-cli](https://github.com/google-github-actions/run-gemini-cli) action with project-specific review instructions defined in [`GEMINI.md`](GEMINI.md).

**Features:**
- Triggered by `@gemini-cli` comment on any open PR (`issue_comment` event)
- Security gate blocks execution for forked PRs to protect secrets
- Reviews the PR diff following project-specific guardrails (secrets, DOKS node pools, GitOps migration, Terragrunt DRY, lifecycle safety)
- Posts structured review feedback as a PR comment (TL;DR, Architecture Health Table, detailed findings)
- Uses `gemini-flash-lite-latest` model via `GEMINI_API_KEY` secret

#### Change Detection Logic

- **Module changes** (e.g., `modules/network/main.tf`): Plans ALL environments (dev, stage, prod)
- **Live changes** (e.g., `live/dev/network/terragrunt.hcl`): Plans only the specific environment
- **Detected modules**: network, kubernetes, monitoring, argocd

#### Composite Actions

**[setup-terragrunt](.github/actions/setup-terragrunt/action.yml)**
- Installs Terraform 1.14.0
- Installs Terragrunt 0.93.11
- Installs Doppler CLI

**[terragrunt-exec](.github/actions/terragrunt-exec/action.yml)**
- Executes Terragrunt commands with Doppler secrets injection
- Handles exit codes properly for workflow failure detection
- Captures output for PR comments
- Uses `tf-var` name transformer for Terraform variables
- TF Cloud token passed directly to avoid transformation

#### Secrets Management

The workflow uses a hybrid approach:
- **Doppler**: Terraform input variables (e.g., `DO_TOKEN` → `TF_VAR_do_token`)
- **GitHub Secrets**: Terraform Cloud token (`TF_CLOUD_TOKEN` → `TF_TOKEN_app_terraform_io`)

---

## Development Roadmap

### Phase 1: Foundation (Complete)

- [x] Multi-environment Terragrunt setup (dev/stage/prod)
- [x] Network module (VPC per environment)
- [x] Kubernetes module (DOKS with app + monitoring node pools, taints, auto-scaling)
- [x] Monitoring module (VictoriaMetrics + Grafana via Helm)
- [x] Doppler secrets management integration
- [x] Terraform Cloud remote state
- [x] Pre-commit hooks (fmt, tflint, tfsec, trivy, checkov, terraform-docs)
- [x] CI/CD pipelines (PR validation, deployment, destroy, AI code review)
- [x] Security scanning in CI (Trivy, Checkov, tfsec)
- [x] Cost estimation (Infracost)
- [x] Architecture documentation and troubleshooting guide

### Phase 2: GitOps with ArgoCD (In Progress)

- [x] Bootstrap ArgoCD via Terraform Helm chart
- [x] DigitalOcean LoadBalancer provisioning for ArgoCD UI
- [x] GitHub OAuth SSO prepared (Dex connector, team-scoped RBAC)
- [x] Secure secret handling (`set_sensitive` for OAuth client secret)
- [ ] Enable HTTPS on ArgoCD LB (cert-manager or DO-managed TLS)
- [ ] Configure GitHub OAuth App and activate Dex SSO
- [ ] Migrate monitoring stack from Terraform Helm to ArgoCD Application
- [ ] Implement App-of-Apps pattern for workload management

### Phase 3: Observability & Application Deployment

- [ ] Custom Grafana dashboards for cluster and application metrics
- [ ] Loki for centralized log aggregation
- [ ] Tempo for distributed tracing + OpenTelemetry Collector
- [ ] Alerting rules and on-call notification routing
- [ ] SLO/SLI definitions with error budget tracking
- [ ] Sample microservice applications with Helm charts
- [ ] Environment-specific overlays (dev/stage/prod)

### Phase 4: Progressive Delivery & Security Hardening

- [ ] Argo Rollouts (canary and blue-green deployment strategies)
- [ ] Metric-based rollout analysis
- [ ] Pod Security Standards
- [ ] Network policies for namespace isolation
- [ ] OPA Gatekeeper policies
- [ ] Falco runtime security monitoring

### Phase 5: Production Hardening

- [ ] Velero backup/restore
- [ ] Disaster recovery procedures (documented RTO/RPO)
- [ ] Kubecost for cost visibility
- [ ] Resource quotas and right-sizing
- [ ] Terratest for infrastructure testing
- [ ] Chaos engineering (LitmusChaos)

### Phase 6: Platform Engineering (Future)

- [ ] Service mesh evaluation (Istio/Linkerd)
- [ ] Backstage developer portal
- [ ] Multi-cluster federation
- [ ] Multi-region deployment

---

## Usage

### Environment Management

```bash
# Development environment
make plan-dev      # Preview changes
make run-dev       # Apply changes
make destroy-dev   # Destroy infrastructure

# Staging environment
make plan-stage
make run-stage
make destroy-stage

# Production environment
make plan-prod
make run-prod
make destroy-prod

# All environments
make plan-all      # Plan all environments
make apply-all     # Apply all environments (use with caution!)
make destroy-all   # Destroy all environments (dangerous!)
```

### Direct Terragrunt Commands

```bash
# Navigate to specific environment
cd infra/terraform/live/dev/network

# Initialize
doppler run --name-transformer tf-var -- terragrunt init

# Plan
doppler run --name-transformer tf-var -- terragrunt plan

# Apply
doppler run --name-transformer tf-var -- terragrunt apply

# Run all modules in environment
cd infra/terraform/live/dev
doppler run --name-transformer tf-var -- terragrunt run-all apply
```

### Accessing Kubernetes Clusters

```bash
# Get kubeconfig from DigitalOcean
doctl kubernetes cluster kubeconfig save dev-cluster

# Verify access
kubectl get nodes
kubectl get pods --all-namespaces
```

### Accessing ArgoCD

```bash
# Port-forward to ArgoCD server (Phase 1 — server.insecure=true, HTTP only)
kubectl port-forward svc/argocd-server -n argocd 8080:80

# Get the initial admin password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d

# Open http://localhost:8080 and login with user "admin"

# Get the LoadBalancer external IP (reserved for future HTTPS setup)
kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### Accessing Grafana

```bash
# Port-forward to Grafana
kubectl port-forward svc/vm-stack-grafana -n monitoring 3000:80

# Get the admin password
kubectl get secret vm-stack-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d

# Open http://localhost:3000 and login with user "admin"
```

---

## Module Documentation

### Network Module

**Location**: [infra/terraform/modules/network/](infra/terraform/modules/network/)

Provisions a VPC with environment-specific CIDR blocks.

**Inputs**:
- `environment` - Environment name (dev/stage/prod)
- `region` - DigitalOcean region (default: fra1)
- `vpc_cidr` - CIDR block for VPC

**Outputs**:
- `vpc_id` - VPC identifier
- `vpc_name` - VPC name
- `vpc_region` - VPC region

### Kubernetes Module

**Location**: [infra/terraform/modules/kubernetes/](infra/terraform/modules/kubernetes/)

Provisions a DOKS cluster with separate node pools for applications and monitoring.

**Features**:
- Auto-scaling node pools
- Dedicated monitoring node pool (tainted `service=monitoring:NoSchedule`)
- App pool untainted to allow DO system components (CoreDNS, CSI driver)
- Auto-upgrade enabled
- Maintenance window configuration

**Inputs**: See [variables.tf](infra/terraform/modules/kubernetes/variables.tf)

**Outputs**: Cluster ID, endpoints, kubeconfig (sensitive)

### Monitoring Module

**Location**: [infra/terraform/modules/monitoring/](infra/terraform/modules/monitoring/)

Deploys VictoriaMetrics observability stack to Kubernetes clusters.

**Features**:
- VictoriaMetrics time-series database
- Grafana for visualization
- Kubernetes metrics collection
- Customizable retention period
- Helm-based deployment with atomic rollback

**Inputs**: See [variables.tf](infra/terraform/modules/monitoring/variables.tf)

**Outputs**: Namespace name, Helm release status

### ArgoCD Module

**Location**: [infra/terraform/modules/argocd/](infra/terraform/modules/argocd/)

Bootstraps ArgoCD as the GitOps controller via Helm chart, with a LoadBalancer for UI access.

**Features**:
- ArgoCD deployed via `argo-cd` Helm chart (pinned version)
- DigitalOcean LoadBalancer for external access
- Redis auth secret pre-created via Terraform (`redisSecretInit` job disabled)
- GitHub OAuth SSO via Dex (conditionally enabled)
- Team-scoped RBAC (`github_admin_team` variable)
- OAuth client secret kept out of Helm values via `set_sensitive`
- Atomic rollback on failed upgrades
- Phased rollout: LB provisioned first, HTTPS and OAuth configured later

**Inputs**: See [variables.tf](infra/terraform/modules/argocd/variables.tf)

**Outputs**: Namespace, Helm release name, Helm release status

---

## Best Practices Demonstrated

### Infrastructure as Code
- ✅ DRY principle with Terragrunt
- ✅ Module reusability
- ✅ Environment parameterization
- ✅ Remote state management
- ✅ State locking

### Security
- ✅ Secrets managed via Doppler (not in code)
- ✅ Sensitive Terraform outputs and `set_sensitive` for Helm secrets
- ✅ Lifecycle protection on critical resources
- ✅ Pre-commit hooks (tflint, tfsec, trivy, checkov)
- ✅ Security scanning in CI pipeline (Trivy, Checkov, tfsec)
- ✅ ArgoCD RBAC with team-scoped admin, default readonly
- 🚧 Network policies (planned)
- 🚧 OPA Gatekeeper (planned)

### Operational Excellence
- ✅ Multi-environment strategy with graduated sizing
- ✅ Automated deployments via Makefile and CI/CD
- ✅ GitOps foundation with ArgoCD
- ✅ Monitoring stack (VictoriaMetrics + Grafana)
- ✅ Node pool isolation (monitoring taint + nodeSelector, untainted app pool for system pods)
- ✅ Atomic Helm rollbacks on failure
- 🚧 Disaster recovery procedures (planned)

### Cost Optimization
- ✅ Auto-scaling enabled
- ✅ Right-sized node pools per environment
- ✅ Cost estimation via Infracost in CI
- 🚧 Kubecost for runtime cost visibility (planned)

---

## Skills Demonstrated

This project showcases proficiency in:

- **Infrastructure as Code**: Terraform + Terragrunt advanced patterns (DRY configs, mock outputs, per-module providers)
- **Cloud Platforms**: DigitalOcean Kubernetes (DOKS) with VPC, node pools, load balancers
- **Container Orchestration**: Kubernetes node taints/tolerations, auto-scaling, namespace isolation
- **GitOps**: ArgoCD bootstrapped via Terraform, phased rollout strategy
- **Secrets Management**: Doppler integration, `set_sensitive` for Helm secrets
- **Observability**: VictoriaMetrics + Grafana monitoring stack
- **CI/CD**: GitHub Actions with smart change detection, matrix strategy, security scanning, AI code review
- **Security**: Pre-commit hooks, CI security scanning (Trivy, Checkov, tfsec), RBAC, sensitive value handling
- **SRE Practices**: Atomic rollbacks, node pool isolation, auto-scaling, cost estimation

---

## Contributing

This is a personal portfolio project, but suggestions and feedback are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contact & Portfolio

**Author**: Maksym Kruk
**LinkedIn**: [https://www.linkedin.com/in/krukmaksym/](LinkedIn)
**GitHub**: [https://github.com/krukmaksym](GitHub)

---

## Acknowledgments

- DigitalOcean for cloud infrastructure
- Gruntwork for Terragrunt inspiration
- The CNCF and Kubernetes community
- Anton Babenko for terraform pre-commit hooks

---

## Project Metrics

| Metric | Value |
|--------|-------|
| Environments | 3 (dev, stage, prod) |
| Terraform Modules | 4 (network, kubernetes, monitoring, argocd) |
| Lines of HCL/YAML | ~718 |
| Cloud Regions | 1 (fra1) |
| Kubernetes Version | 1.35.1-do.0 |
| Total Nodes (dev) | 3-5 (auto-scaled: 2-4 app + 1 monitoring) |
| GitHub Actions Workflows | 5 (PR validation, deployment, destroy, Claude review, Gemini review) |

---

**Status**: 🚧 Active Development
**Last Updated**: 2026-03-16
**Version**: 0.5.0 (ArgoCD GitOps Bootstrap)
