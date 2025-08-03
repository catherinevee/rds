# Aurora PostgreSQL Example
# This example demonstrates Aurora PostgreSQL-specific configurations and features

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

# Data source to get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create an Aurora PostgreSQL cluster
module "aurora_postgresql" {
  source = "../../"

  # Basic configuration
  create_rds_cluster = true
  identifier         = "aurora-postgresql-cluster"
  
  # Engine configuration
  engine         = "aurora-postgresql"
  engine_version = "15.4"
  cluster_engine_mode = "provisioned"
  
  # Authentication
  cluster_master_username = "postgres"
  cluster_master_password = "your-secure-password-123!"
  
  # Create security group
  create_security_group = true
  security_group_name   = "aurora-postgresql-sg"
  security_group_description = "Security group for Aurora PostgreSQL cluster"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "aurora-postgresql-subnet-group"
  
  # Cluster instances
  cluster_instances = [
    {
      identifier     = "primary"
      instance_class = "db.r6g.large"
      availability_zone = data.aws_availability_zones.available.names[0]
      promotion_tier = 0
    },
    {
      identifier     = "replica-1"
      instance_class = "db.r6g.large"
      availability_zone = data.aws_availability_zones.available.names[1]
      promotion_tier = 1
    },
    {
      identifier     = "replica-2"
      instance_class = "db.r6g.large"
      availability_zone = data.aws_availability_zones.available.names[2]
      promotion_tier = 2
    }
  ]
  
  # Database configuration
  cluster_database_name = "production_db"
  cluster_port = 5432
  
  # Backup and maintenance
  cluster_backup_retention_period = 7
  cluster_preferred_backup_window = "03:00-04:00"
  cluster_preferred_maintenance_window = "sun:04:00-sun:05:00"
  
  # Storage and encryption
  cluster_storage_encrypted = true
  
  # CloudWatch Logs for Aurora PostgreSQL
  cluster_enable_cloudwatch_logs_exports = ["postgresql", "error", "general"]
  
  # Security
  cluster_deletion_protection = true
  cluster_skip_final_snapshot = false
  cluster_final_snapshot_identifier = "aurora-postgresql-final-snapshot"
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "aurora-postgresql-example"
    Owner       = "terraform"
    Database    = "aurora-postgresql"
    Engine      = "aurora-postgresql"
  }
}

# Outputs
output "aurora_postgresql_cluster_endpoint" {
  description = "Aurora PostgreSQL cluster endpoint"
  value       = module.aurora_postgresql.db_cluster_endpoint
}

output "aurora_postgresql_reader_endpoint" {
  description = "Aurora PostgreSQL reader endpoint"
  value       = module.aurora_postgresql.db_cluster_reader_endpoint
}

output "aurora_postgresql_port" {
  description = "Aurora PostgreSQL port"
  value       = module.aurora_postgresql.db_cluster_port
}

output "aurora_postgresql_database_name" {
  description = "Aurora PostgreSQL database name"
  value       = module.aurora_postgresql.db_cluster_database_name
} 