# PostgreSQL RDS Example
# This example demonstrates PostgreSQL-specific configurations and features

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

# Create a PostgreSQL RDS instance with PostgreSQL-specific features
module "postgresql_db" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "postgresql-production"
  
  # Engine configuration
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.medium"
  
  # Storage
  allocated_storage = 100
  storage_type     = "gp3"
  storage_encrypted = true
  iops             = 3000
  
  # Authentication
  username = "postgres"
  password = "your-secure-password-123!"
  
  # Database configuration
  db_name = "production_db"
  port    = 5432
  
  # Create security group
  create_security_group = true
  security_group_name   = "postgresql-sg"
  security_group_description = "Security group for PostgreSQL RDS instance"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "postgresql-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 14
  backup_window          = "02:00-03:00"
  maintenance_window     = "sun:03:00-sun:04:00"
  
  # High availability
  multi_az = true
  
  # Monitoring and logging
  monitoring_interval = 60
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # CloudWatch Logs for PostgreSQL
  enable_cloudwatch_logs_exports = ["postgresql", "error", "general"]
  
  # PostgreSQL-specific configurations
  parameter_group_name = "default.postgres15"
  
  # Security
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "postgresql-production-final-snapshot"
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "postgresql-example"
    Owner       = "terraform"
    Database    = "postgresql"
    Engine      = "postgres"
  }
}

# Outputs
output "postgresql_endpoint" {
  description = "PostgreSQL connection endpoint"
  value       = module.postgresql_db.db_instance_endpoint
}

output "postgresql_port" {
  description = "PostgreSQL port"
  value       = module.postgresql_db.db_instance_port
}

output "postgresql_database_name" {
  description = "PostgreSQL database name"
  value       = module.postgresql_db.db_instance_name
} 