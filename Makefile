POLICIES_DIR := policies/aws

.PHONY: test
test:
ifndef folder
	$(error folder is not set. Usage: make test folder=<service-folder>  e.g. make test folder=s3)
endif
	tfpolicy test --policies=$(if $(filter policies/%,$(folder)),$(folder),$(POLICIES_DIR)/$(folder))

.PHONY: tests
tests:
	@FAILED=""; \
	for dir in $(POLICIES_DIR)/*/; do \
		dir=$${dir%/}; \
		echo "==> Testing $$dir"; \
		if ! tfpolicy test --policies="$$dir"; then \
			failed="$$failed $$dir"; \
		fi; \
	done; \
	if [ -n "$$failed" ]; then \
		echo ""; \
		echo "failed:"; \
		echo "$$failed" | tr ' ' '\n' | grep -v '^$$'; \
		exit 1; \
	else \
		echo ""; \
		echo "All tests passed."; \
	fi
