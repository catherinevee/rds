# Basic RDS Instance Example
# This example demonstrates how to create a simple RDS instance

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

# Create a basic RDS instance
module "rds_basic" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "basic-mysql-db"
  
  # Engine configuration
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  # Storage
  allocated_storage = 20
  storage_type     = "gp2"
  storage_encrypted = true
  
  # Authentication
  username = "admin"
  password = "your-secure-password-123!"
  
  # Create security group
  create_security_group = true
  security_group_name   = "basic-rds-sg"
  security_group_description = "Security group for basic RDS MySQL instance"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "basic-rds-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  # Tags
  tags = {
    Environment = "development"
    Project     = "basic-example"
    Owner       = "terraform"
  }
} 