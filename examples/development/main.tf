# Development RDS Example
# This example demonstrates a minimal RDS configuration suitable for development environments

terraform {
  required_version = ">= 1.13.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=6.2.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Data source to get default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create a development RDS instance with minimal configuration
module "development_db" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "dev-database"
  
  # Engine configuration
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  # Storage
  allocated_storage = 20
  storage_type     = "gp2"
  storage_encrypted = false  # Disabled for development to reduce costs
  
  # Authentication
  username = "dev_user"
  password = "dev-password-123!"
  
  # Database configuration
  db_name = "dev_db"
  
  # Create security group
  create_security_group = true
  security_group_name   = "dev-db-sg"
  security_group_description = "Security group for development database"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "dev-db-subnet-group"
  
  # Backup and maintenance (minimal for development)
  backup_retention_period = 1
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  # High availability (disabled for development)
  multi_az = false
  
  # Monitoring (disabled for development)
  monitoring_interval = 0
  
  # Performance Insights (disabled for development)
  performance_insights_enabled = false
  
  # Security (relaxed for development)
  deletion_protection = false
  skip_final_snapshot = true
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "development"
    Project     = "dev-example"
    Owner       = "terraform"
    Purpose     = "development"
    AutoShutdown = "true"
  }
}

# Outputs
output "dev_database_endpoint" {
  description = "Development database connection endpoint"
  value       = module.development_db.db_instance_endpoint
}

output "dev_database_port" {
  description = "Development database port"
  value       = module.development_db.db_instance_port
}

output "dev_database_name" {
  description = "Development database name"
  value       = module.development_db.db_instance_name
}

output "dev_database_username" {
  description = "Development database username"
  value       = module.development_db.db_instance_username
} 