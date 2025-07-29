# RDS Module Makefile
# Common operations for the RDS Terraform module

.PHONY: help init plan apply destroy validate fmt lint clean test examples

# Default target
help:
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan Terraform changes"
	@echo "  apply     - Apply Terraform changes"
	@echo "  destroy   - Destroy Terraform resources"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  fmt       - Format Terraform code"
	@echo "  lint      - Lint Terraform code with tflint"
	@echo "  clean     - Clean up temporary files"
	@echo "  test      - Run tests"
	@echo "  examples  - Test examples"

# Initialize Terraform
init:
	terraform init

# Plan Terraform changes
plan:
	terraform plan

# Apply Terraform changes
apply:
	terraform apply

# Destroy Terraform resources
destroy:
	terraform destroy

# Validate Terraform configuration
validate:
	terraform validate

# Format Terraform code
fmt:
	terraform fmt -recursive

# Lint Terraform code
lint:
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --init; \
		tflint; \
	else \
		echo "tflint not found. Install with: go install github.com/terraform-linters/tflint/cmd/tflint@latest"; \
	fi

# Clean up temporary files
clean:
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -rf .tflint.d
	find . -name "*.tfstate*" -delete
	find . -name ".terraform.tfstate.lock.info" -delete

# Run tests
test:
	@echo "Running Terraform validation..."
	terraform validate
	@echo "Running Terraform format check..."
	terraform fmt -check -recursive
	@echo "Running tflint..."
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --init; \
		tflint; \
	else \
		echo "tflint not found. Skipping lint check."; \
	fi

# Test examples
examples:
	@echo "Testing basic example..."
	cd examples/basic && terraform init && terraform validate
	@echo "Testing Aurora example..."
	cd examples/aurora && terraform init && terraform validate
	@echo "Testing advanced example..."
	cd examples/advanced && terraform init && terraform validate

# Install development dependencies
install-deps:
	@echo "Installing development dependencies..."
	@if command -v go >/dev/null 2>&1; then \
		go install github.com/terraform-linters/tflint/cmd/tflint@latest; \
	else \
		echo "Go not found. Please install Go to use tflint."; \
	fi

# Generate documentation
docs:
	@echo "Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table . > README.md.tmp; \
		mv README.md.tmp README.md; \
	else \
		echo "terraform-docs not found. Install with: go install github.com/terraform-docs/terraform-docs/cmd/terraform-docs@latest"; \
	fi

# Security scan
security-scan:
	@echo "Running security scan..."
	@if command -v terrascan >/dev/null 2>&1; then \
		terrascan scan -i terraform .; \
	else \
		echo "terrascan not found. Install with: go install github.com/tenable/terrascan/cmd/terrascan@latest"; \
	fi

# Pre-commit hooks
pre-commit: fmt lint validate

# CI/CD pipeline
ci: install-deps test security-scan examples 