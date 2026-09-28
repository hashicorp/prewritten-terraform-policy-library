POLICIES_DIR := policies

.PHONY: test
test:
ifndef folder
	$(error folder is not set. Usage: make test folder=<service-folder>  e.g. make test folder=s3)
endif
	tfpolicy validate --policies=$(if $(filter policies/%,$(folder)),$(folder),$(POLICIES_DIR)/$(folder))
	tfpolicy test --policies=$(if $(filter policies/%,$(folder)),$(folder),$(POLICIES_DIR)/$(folder))

.PHONY: tests
tests:
	@echo "==> Collecting policies per provider into tmp/"; \
	rm -rf tmp; \
	for provider_dir in $(POLICIES_DIR)/*/; do \
		provider=$$(basename $$provider_dir); \
		mkdir -p tmp/$$provider; \
		find $$provider_dir -maxdepth 2 -type f \( -name "*.policy.hcl" -o -name "*.policytest.hcl" \) -exec cp {} tmp/$$provider/ \; ; \
	done; \
	for provider_dir in tmp/*/; do \
		provider=$$(basename $$provider_dir); \
		echo "==> Validating $$provider"; \
		if ! tfpolicy validate --policies=$$provider_dir; then \
			rm -rf tmp; \
			echo ""; \
			echo "Validation failed for $$provider."; \
			exit 1; \
		fi; \
		echo "==> Testing $$provider"; \
		if ! tfpolicy test --policies=$$provider_dir; then \
			rm -rf tmp; \
			echo ""; \
			echo "Tests failed for $$provider."; \
			exit 1; \
		fi; \
	done; \
	rm -rf tmp; \
	echo ""; \
	echo "All tests passed."
