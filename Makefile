# ====== CONFIG ======
DOPPLER=doppler run --name-transformer tf-var -- sh -c
LIVE_DIR=infra/terraform/live

# ====== HELPERS ======
run-dev:
	@$(DOPPLER) "cd $(LIVE_DIR)/dev && terragrunt run --all apply"

plan-dev:
	@$(DOPPLER) "cd $(LIVE_DIR)/dev && terragrunt run --all plan"

destroy-dev:
	@$(DOPPLER) "cd $(LIVE_DIR)/dev && terragrunt run --all destroy"


run-stage:
	@$(DOPPLER) "cd $(LIVE_DIR)/stage && terragrunt run --all apply"

plan-stage:
	@$(DOPPLER) "cd $(LIVE_DIR)/stage && terragrunt run --all plan"

destroy-stage:
	@$(DOPPLER) "cd $(LIVE_DIR)/stage && terragrunt run --all destroy"


run-prod:
	@$(DOPPLER) "cd $(LIVE_DIR)/prod && terragrunt run --all apply"

plan-prod:
	@$(DOPPLER) "cd $(LIVE_DIR)/prod && terragrunt run --all plan"

destroy-prod:
	@$(DOPPLER) "cd $(LIVE_DIR)/prod && terragrunt run --all destroy"


# ====== RUN ALL ENVS ======
plan-all:
	@$(DOPPLER) "cd $(LIVE_DIR) && terragrunt run --all plan"

apply-all:
	@$(DOPPLER) "cd $(LIVE_DIR) && terragrunt run --all apply"

destroy-all:
	@$(DOPPLER) "cd $(LIVE_DIR) && terragrunt run --all destroy"