# Troubleshooting Guide

This guide covers common issues encountered when working with the infrastructure and their solutions.

## Terraform & Terragrunt

### Error: `Error acquiring the state lock`
**Symptom**: Terragrunt fails with a message about the state being locked by another user.
**Cause**: A previous run failed or was interrupted, leaving the lock in place, or another CI job is running.
**Solution**:
1. Check if a CI/CD job is currently running in GitHub Actions.
2. If no job is running, force unlock the state (use with caution):
   ```bash
   terragrunt force-unlock <LOCK_ID>
   ```

### Error: `MISSING_DOPPLER_TOKEN` or `401 Unauthorized`
**Symptom**: Terraform/Terragrunt commands fail immediately.
**Cause**: Doppler token is missing or expired in the current shell session.
**Solution**:
1. Ensure you are logged in: `doppler login`
2. Run commands using the wrapper: `make plan-dev` or `doppler run -- terragrunt plan`

## Kubernetes (DOKS)

### Error: `The connection to the server ... was refused`
**Symptom**: `kubectl` commands time out or are refused.
**Cause**: Kubeconfig is outdated or the cluster API endpoint has changed (e.g., after cluster recreation).
**Solution**:
1. Refresh your kubeconfig:
   ```bash
   doctl kubernetes cluster kubeconfig save <cluster-name>
   ```
2. Verify context: `kubectl config current-context`

### Pods stuck in `Pending` state
**Symptom**: Pods are not scheduling on nodes.
**Cause**:
1. Insufficient resources (CPU/Memory).
2. Taint/Toleration mismatch (e.g., trying to schedule app pod on monitoring node without toleration).
**Solution**:
1. Check pod events: `kubectl describe pod <pod-name>`
2. Verify node taints: `kubectl describe node <node-name> | grep Taints`

## Pre-commit Hooks

### Error: `terraform_validate` failed
**Symptom**: Commit is blocked by pre-commit.
**Cause**: Syntax error or missing provider configuration.
**Solution**:
1. Run validation manually to see details:
   ```bash
   pre-commit run terraform_validate -a
   ```
2. If `versions.tf` is missing in a new module, ensure you add `required_providers`.

### Documentation not updating
**Symptom**: `terraform_docs` hook passes but `README.md` is empty.
**Solution**:
Ensure the `README.md` contains the marker tags:
```markdown
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
```
