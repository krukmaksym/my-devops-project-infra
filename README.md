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
┌─────────────────────────────────────────────────────────────┐
│                      DigitalOcean Cloud                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Environment: dev / stage / prod        │    │
│  │                                                     │    │
│  │  ┌──────────────────────────────────────────────┐   │    │
│  │  │           VPC (10.x.0.0/24)                  │   │    │
│  │  │                                              │   │    │
│  │  │  ┌────────────────────────────────────────┐  │   │    │
│  │  │  │  Kubernetes Cluster (DOKS)             │  │   │    │
│  │  │  │                                        │  │   │    │
│  │  │  │  ┌───────────────────────────────────┐ │  │   │    │
│  │  │  │  │   Application Node Pool           │ │  │   │    │
│  │  │  │  │   - Auto-scaling (2-10 nodes)     │ │  │   │    │
│  │  │  │  │   - Tainted for app workloads     │ │  │   │    │
│  │  │  │  └───────────────────────────────────┘ │  │   │    │
│  │  │  │                                        │  │   │    │
│  │  │  │  ┌───────────────────────────────────┐ │  │   │    │
│  │  │  │  │   Monitoring Node Pool            │ │  │   │    │
│  │  │  │  │   - Dedicated for observability   │ │  │   │    │
│  │  │  │  │   - Tainted for monitoring only   │ │  │   │    │
│  │  │  │  └───────────────────────────────────┘ │  │   │    │
│  │  │  └────────────────────────────────────────┘  │   │    │
│  │  └──────────────────────────────────────────────┘   │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘

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
- **Container Orchestration**: Kubernetes (DOKS) 1.34.0
- **State Management**: Terraform Cloud
- **Secrets Management**: Doppler

### DevOps Tools (Current)
- **CI/CD**: GitHub Actions (automated PR validation)
- **Pre-commit Hooks**: terraform-fmt, terragrunt-fmt
- **Version Control**: Git

### Planned Stack
- **GitOps**: ArgoCD + Argo Rollouts
- **Observability**: Prometheus, Grafana, Loki, Tempo
- **Security**: Trivy, Checkov, tfsec, OPA Gatekeeper
- **Service Mesh**: Istio/Linkerd (future)
- **Backup**: Velero

---

## Project Structure

```
my-devops-project-infra/
├── .github/
│   ├── actions/                  # Reusable composite actions
│   │   ├── setup-terragrunt/     # Install Terraform, Terragrunt, Doppler
│   │   └── terragrunt-exec/      # Execute Terragrunt with Doppler secrets
│   └── workflows/
│       └── terraform-pr.yml      # PR validation workflow
├── .pre-commit-config.yaml      # Pre-commit hooks configuration
├── Makefile                     # Automation shortcuts for Terragrunt
├── README.md                    # This file
├── LICENSE                      # MIT License
└── infra/
    └── terraform/
        ├── modules/              # Reusable Terraform modules
        │   ├── network/          # VPC provisioning
        │   ├── kubernetes/       # DOKS cluster + node pools
        │   └── monitoring/       # [TODO] Observability stack
        └── live/                 # Environment-specific configurations
            ├── root.hcl          # Global Terragrunt config
            ├── _env/             # Environment variable definitions
            │   ├── network.hcl   # Network configs per env
            │   └── kubernetes.hcl # K8s configs per env
            ├── dev/              # Development environment
            │   ├── network/
            │   └── kubernetes/
            ├── stage/            # Staging environment
            │   ├── network/
            │   └── kubernetes/
            └── prod/             # Production environment
                ├── network/
                └── kubernetes/
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

| Component | Status | Description |
|-----------|--------|-------------|
| **Multi-environment setup** | ✅ Complete | dev, stage, prod environments with graduated sizing |
| **Network module** | ✅ Complete | VPC provisioning with environment-specific CIDR blocks |
| **Kubernetes module** | ✅ Complete | DOKS cluster with app + monitoring node pools |
| **Terragrunt DRY config** | ✅ Complete | Centralized configuration, minimal duplication |
| **Doppler integration** | ✅ Complete | Secure secret management via Makefile |
| **Remote state** | ✅ Complete | Terraform Cloud backend |
| **Pre-commit (basic)** | ✅ Complete | terraform_fmt, terragrunt_fmt |
| **Tagging strategy** | ✅ Complete | Consistent tagging across resources |
| **Auto-scaling** | ✅ Complete | Node pool auto-scaling configured |
| **Lifecycle protection** | ✅ Complete | prevent_destroy on critical resources |
| **CI/CD Pipeline** | ✅ Complete | GitHub Actions PR validation workflow |

### 🚧 In Progress / Planned

| Component | Priority | Status | Target Completion |
|-----------|----------|--------|-------------------|
| **Enhanced pre-commit hooks** | High | 🚧 Planned | Week 1 |
| **Monitoring module** | High | 🚧 Planned | Week 2-3 |
| **Module documentation** | High | 🚧 Planned | Week 1 |
| **ArgoCD setup** | Medium | 📋 Planned | Week 4-5 |
| **GitOps workflow** | Medium | 📋 Planned | Week 5-6 |
| **Observability dashboards** | Medium | 📋 Planned | Week 6-7 |
| **Security scanning** | High | 📋 Planned | Week 3-4 |
| **Disaster recovery** | High | 📋 Planned | Week 8-9 |
| **Cost optimization** | Medium | 📋 Planned | Week 10+ |

---

## CI/CD Pipeline

### GitHub Actions Workflow

The project includes an automated PR validation workflow ([`.github/workflows/terraform-pr.yml`](.github/workflows/terraform-pr.yml)) that runs on every pull request to `main`.

#### Workflow Features

1. **Security Gate**: Prevents workflow execution for forked PRs to protect secrets
2. **Smart Change Detection**: Identifies modified Terraform files and builds a matrix of affected environments
3. **Terraform Format Check**: Validates code formatting across all Terraform files
4. **Parallel Validation**: Runs `terragrunt validate` in parallel for all affected env/module combinations
5. **Parallel Planning**: Generates Terraform plans for all changes and posts summaries as PR comments
6. **Summary Report**: Aggregates results from all jobs and provides overall workflow status

#### Change Detection Logic

- **Module changes** (e.g., `modules/network/main.tf`): Plans ALL environments (dev, stage, prod)
- **Live changes** (e.g., `live/dev/network/terragrunt.hcl`): Plans only the specific environment

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

### Phase 1: Foundation & Security (Weeks 1-4)

#### Week 1: Enhanced Pre-commit & Documentation
- [ ] Enable all pre-commit hooks (terraform_validate, tflint, tfsec, checkov)
- [ ] Auto-generate module documentation with terraform-docs
- [ ] Create architecture diagrams
- [ ] Add troubleshooting guide

#### Week 2-3: Monitoring Stack
- [ ] Implement monitoring Terraform module
- [ ] Deploy kube-prometheus-stack via Helm
- [ ] Configure Grafana dashboards
- [ ] Set up Loki for centralized logging
- [ ] Create initial alerting rules

#### Week 3-4: Enhanced CI/CD Pipeline
- [x] Create GitHub Actions PR validation workflow
- [x] Smart change detection and matrix strategy
- [x] Parallel validate and plan jobs
- [x] PR comment with plan summaries
- [ ] Add security scanning (trivy, checkov, tfsec)
- [ ] Cost estimation (Infracost)
- [ ] Auto-apply on merge to main
- [ ] Add pipeline status badges
- [ ] Configure notifications (Slack/Discord)

---

### Phase 2: GitOps & Progressive Delivery (Weeks 4-7)

#### Week 4-5: ArgoCD Implementation
- [ ] Deploy ArgoCD to K8s cluster
- [ ] Implement App-of-Apps pattern
- [ ] Create sample microservice applications
- [ ] Configure automated sync policies
- [ ] Set up RBAC and access control

#### Week 6: Application Deployment
- [ ] Create Helm charts for sample apps
- [ ] Environment-specific overlays (dev/stage/prod)
- [ ] External Secrets Operator integration
- [ ] Image update automation

#### Week 7: Progressive Delivery
- [ ] Deploy Argo Rollouts
- [ ] Implement canary deployment strategy
- [ ] Configure blue-green deployments
- [ ] Metric-based rollout analysis

---

### Phase 3: Advanced Observability (Weeks 7-9)

#### Week 8: Distributed Tracing
- [ ] Deploy Tempo for distributed tracing
- [ ] OpenTelemetry Collector setup
- [ ] Instrument sample applications
- [ ] Create trace-based dashboards

#### Week 9: SLO/SLI Implementation
- [ ] Define Service Level Objectives
- [ ] Implement SLI monitoring
- [ ] Error budget tracking
- [ ] SLO burn rate alerting

---

### Phase 4: Production Hardening (Weeks 10-13)

#### Week 10: Testing & Quality
- [ ] Implement Terratest for infrastructure testing
- [ ] Add contract tests for APIs
- [ ] Chaos engineering experiments (LitmusChaos)
- [ ] Load testing with K6

#### Week 11: Security Hardening
- [ ] Pod Security Standards implementation
- [ ] Network policies for micro-segmentation
- [ ] OPA Gatekeeper policies
- [ ] Falco runtime security
- [ ] Image scanning in CI/CD

#### Week 12: Disaster Recovery
- [ ] Velero backup/restore setup
- [ ] Database backup automation
- [ ] Document RTO/RPO
- [ ] Conduct DR drill

#### Week 13: Cost Optimization
- [ ] Deploy Kubecost
- [ ] Implement resource quotas
- [ ] Right-sizing recommendations
- [ ] Cost reporting dashboard

---

### Phase 5: Advanced Features (Weeks 14+)

#### Service Mesh (Optional)
- [ ] Evaluate Istio vs Linkerd
- [ ] Implement mTLS between services
- [ ] Advanced traffic management
- [ ] Observability integration

#### Platform Engineering
- [ ] Deploy Backstage developer portal
- [ ] Self-service infrastructure templates
- [ ] Golden path documentation
- [ ] Developer onboarding automation

#### Multi-Cluster (Advanced)
- [ ] Implement cluster federation
- [ ] Multi-region deployment
- [ ] Global load balancing
- [ ] Cross-cluster service discovery

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
- Dedicated monitoring node pool
- Node taints and tolerations
- Auto-upgrade enabled
- Maintenance window configuration

**Inputs**: See [variables.tf](infra/terraform/modules/kubernetes/variables.tf)

**Outputs**: Cluster ID, endpoints, kubeconfig (sensitive)

---

## Best Practices Demonstrated

### Infrastructure as Code
- ✅ DRY principle with Terragrunt
- ✅ Module reusability
- ✅ Environment parameterization
- ✅ Remote state management
- ✅ State locking

### Security
- ✅ Sensitive outputs marked appropriately
- ✅ Secrets managed via Doppler (not in code)
- ✅ Lifecycle protection on critical resources
- ✅ Pre-commit hooks for validation
- 🚧 Security scanning in CI/CD (planned)
- 🚧 RBAC and least privilege (planned)

### Operational Excellence
- ✅ Multi-environment strategy
- ✅ Automated deployments via Makefile
- ✅ Consistent tagging
- ✅ Node pool isolation
- 🚧 Comprehensive monitoring (planned)
- 🚧 Disaster recovery procedures (planned)

### Cost Optimization
- ✅ Auto-scaling enabled
- ✅ Right-sized node pools per environment
- 🚧 Cost monitoring and alerting (planned)

---

## Skills Demonstrated

This project showcases proficiency in:

- **Infrastructure as Code**: Terraform + Terragrunt advanced patterns
- **Cloud Platforms**: DigitalOcean Kubernetes (DOKS)
- **Container Orchestration**: Kubernetes architecture and operations
- **Secrets Management**: External secret management with Doppler
- **GitOps**: Infrastructure and application deployment workflows (planned)
- **Observability**: Metrics, logging, tracing, and alerting (planned)
- **CI/CD**: Automated testing and deployment pipelines (planned)
- **Security**: Scanning, policies, and hardening (planned)
- **SRE Practices**: SLOs, incident response, disaster recovery (planned)

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
| Terraform Modules | 2 (network, kubernetes) |
| Lines of Terraform Code | ~200 |
| Cloud Regions | 1 (fra1) |
| Kubernetes Versions | 1.34.0-do.0 |
| Total Nodes (dev) | 2-4 (auto-scaled) |

---

**Status**: 🚧 Active Development
**Last Updated**: 2025-11-28
**Version**: 0.3.0 (CI/CD Pipeline Complete)
