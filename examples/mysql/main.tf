# MySQL RDS Example
# This example demonstrates MySQL-specific configurations and features

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

# Create a MySQL RDS instance with MySQL-specific features
module "mysql_db" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "mysql-production"
  
  # Engine configuration
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.medium"
  
  # Storage
  allocated_storage = 100
  storage_type     = "gp3"
  storage_encrypted = true
  iops             = 3000
  
  # Authentication
  username = "admin"
  password = "your-secure-password-123!"
  
  # Database configuration
  db_name = "production_db"
  port    = 3306
  
  # Character set
  character_set_name = "utf8mb4"
  
  # Create security group
  create_security_group = true
  security_group_name   = "mysql-sg"
  security_group_description = "Security group for MySQL RDS instance"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "mysql-subnet-group"
  
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
  
  # CloudWatch Logs for MySQL
  enable_cloudwatch_logs_exports = ["error", "general", "slow_query"]
  
  # MySQL-specific configurations
  parameter_group_name = "default.mysql8.0"
  
  # Security
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "mysql-production-final-snapshot"
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "mysql-example"
    Owner       = "terraform"
    Database    = "mysql"
    Engine      = "mysql"
  }
}

# Outputs
output "mysql_endpoint" {
  description = "MySQL connection endpoint"
  value       = module.mysql_db.db_instance_endpoint
}

output "mysql_port" {
  description = "MySQL port"
  value       = module.mysql_db.db_instance_port
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = module.mysql_db.db_instance_name
} 