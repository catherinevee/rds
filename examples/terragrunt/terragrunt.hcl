# Terragrunt RDS Example
# This example demonstrates how to use the RDS module with Terragrunt

# Include the root terragrunt.hcl configuration
include "root" {
  path = find_in_parent_folders()
}

# Include common variables
include "common" {
  path = find_in_parent_folders("common.hcl")
}

# Terraform configuration
terraform {
  source = "../../"
}

# Inputs for the RDS module
inputs = {
  # Basic configuration
  create_rds_instance = true
  identifier         = "terragrunt-example-db"
  
  # Engine configuration
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  # Storage
  allocated_storage = 50
  storage_type     = "gp3"
  storage_encrypted = true
  iops             = 3000
  
  # Authentication
  username = "admin"
  password = "terragrunt-password-123!"
  
  # Database configuration
  db_name = "terragrunt_db"
  
  # Create security group
  create_security_group = true
  security_group_name   = "terragrunt-db-sg"
  security_group_description = "Security group for Terragrunt RDS example"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = dependency.vpc.outputs.private_subnets
  subnet_group_name      = "terragrunt-db-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 7
  backup_window          = "02:00-03:00"
  maintenance_window     = "sun:03:00-sun:04:00"
  
  # High availability
  multi_az = false
  
  # Monitoring and logging
  monitoring_interval = 60
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # CloudWatch Logs
  enable_cloudwatch_logs_exports = ["error", "general", "slow_query"]
  
  # Security
  deletion_protection = false
  skip_final_snapshot = true
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "terragrunt-example"
    Project     = "terragrunt-rds"
    Owner       = "terraform"
    ManagedBy   = "terragrunt"
  }
}

# Dependencies
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    private_subnets = ["subnet-12345678", "subnet-87654321"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
} 