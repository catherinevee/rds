# Aurora Cluster Example
# This example demonstrates how to create an Aurora MySQL cluster

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

# Create an Aurora MySQL cluster
module "aurora_cluster" {
  source = "../../"

  # Basic configuration
  create_rds_cluster = true
  identifier         = "aurora-mysql-cluster"
  
  # Engine configuration
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.1"
  cluster_engine_mode = "provisioned"
  
  # Authentication
  cluster_master_username = "admin"
  cluster_master_password = "your-secure-password-123!"
  
  # Create security group
  create_security_group = true
  security_group_name   = "aurora-cluster-sg"
  security_group_description = "Security group for Aurora MySQL cluster"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "aurora-cluster-subnet-group"
  
  # Cluster instances
  cluster_instances = [
    {
      identifier     = "primary"
      instance_class = "db.r6g.large"
      availability_zone = data.aws_availability_zones.available.names[0]
      promotion_tier = 0
    },
    {
      identifier     = "replica"
      instance_class = "db.r6g.large"
      availability_zone = data.aws_availability_zones.available.names[1]
      promotion_tier = 1
    }
  ]
  
  # Backup and maintenance
  cluster_backup_retention_period = 7
  cluster_preferred_backup_window = "03:00-04:00"
  cluster_preferred_maintenance_window = "sun:04:00-sun:05:00"
  
  # Storage and encryption
  cluster_storage_encrypted = true
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "aurora-example"
    Owner       = "terraform"
  }
} 