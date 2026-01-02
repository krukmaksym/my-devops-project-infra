# Terragrunt Best Practices

## Automation & CI/CD

### `run --all` vs Single Module Commands
 
 When executing Terragrunt commands in CI/CD pipelines, it is important to distinguish between `run --all` commands (working on multiple modules) and single-module commands.
 
 #### `run --all apply` / `run --all destroy`
 
 - **Auto-Approval**: When running in non-interactive mode (e.g., via `TG_NON_INTERACTIVE=true`), Terragrunt **automatically** assumes/passes auto-approval for `run --all` operations.
 - **Flags**: You **MUST NOT** pass the `-auto-approve` flag to `terragrunt run --all apply` or `terragrunt run --all destroy`. Doing so will result in a `flag provided but not defined: -auto-approve` error because the `run --all` command itself does not accept this flag (it handles the approval for underlying modules internally).
 
 **Correct:**
 ```bash
 export TG_NON_INTERACTIVE=true
 terragrunt run --all apply
 ```
 
 **Incorrect:**
 ```bash
 terragrunt run --all apply -auto-approve  # This will fail
 ```

#### Single Module `apply` / `destroy`

- **Auto-Approval**: For standard `terragrunt apply` or `terragrunt destroy` on a single module, you **MUST** explicitly pass `-auto-approve` to avoid interactive prompts in a CI environment.

**Correct:**
```bash
terragrunt apply -auto-approve
```
