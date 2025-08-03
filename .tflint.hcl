plugin "aws" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
  module = true
  force  = false
}

# AWS Provider Configuration
rule "aws_provider_missing_default_tags" {
  enabled = true
}

rule "aws_provider_missing_region" {
  enabled = true
}

# RDS Specific Rules
rule "aws_db_instance_invalid_type" {
  enabled = true
}

rule "aws_db_instance_invalid_engine" {
  enabled = true
}

rule "aws_db_instance_invalid_storage_type" {
  enabled = true
}

rule "aws_db_instance_invalid_backup_retention_period" {
  enabled = true
}

rule "aws_db_instance_invalid_allocated_storage" {
  enabled = true
}

rule "aws_db_instance_invalid_iops" {
  enabled = true
}

rule "aws_db_instance_invalid_monitoring_interval" {
  enabled = true
}

rule "aws_db_instance_invalid_performance_insights_retention_period" {
  enabled = true
}

# Security Group Rules
rule "aws_security_group_invalid_name" {
  enabled = true
}

rule "aws_security_group_invalid_description" {
  enabled = true
}

rule "aws_security_group_rule_invalid_type" {
  enabled = true
}

rule "aws_security_group_rule_invalid_protocol" {
  enabled = true
}

# Subnet Group Rules
rule "aws_db_subnet_group_invalid_name" {
  enabled = true
}

rule "aws_db_subnet_group_invalid_description" {
  enabled = true
}

# CloudWatch Log Group Rules
rule "aws_cloudwatch_log_group_invalid_name" {
  enabled = true
}

rule "aws_cloudwatch_log_group_invalid_retention_in_days" {
  enabled = true
}

# General Terraform Rules
rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

# Variable and Output Rules
rule "terraform_variable_separate" {
  enabled = true
}

rule "terraform_output_separate" {
  enabled = true
}

# Formatting Rules
rule "terraform_fmt" {
  enabled = true
}

# Best Practices
rule "terraform_no_env_vars" {
  enabled = true
}

rule "terraform_no_required_providers" {
  enabled = false  # We want to require providers
}

rule "terraform_no_required_version" {
  enabled = false  # We want to require version
} 