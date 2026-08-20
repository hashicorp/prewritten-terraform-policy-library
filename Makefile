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
	@echo "==> Collecting all policies into tmp/"; \
	rm -rf tmp && mkdir -p tmp; \
	find $(POLICIES_DIR) -maxdepth 3 -type f \( -name "*.policy.hcl" -o -name "*.policytest.hcl" \) -exec cp {} tmp/ \; ; \
	echo "==> Validating tmp/"; \
	if ! tfpolicy validate --policies=tmp; then \
		rm -rf tmp; \
		echo ""; \
		echo "Validation failed."; \
		exit 1; \
	fi; \
	echo "==> Testing tmp/"; \
	if ! tfpolicy test --policies=tmp; then \
		rm -rf tmp; \
		echo ""; \
		echo "Tests failed."; \
		exit 1; \
	fi; \
	rm -rf tmp; \
	echo ""; \
	echo "All tests passed."
