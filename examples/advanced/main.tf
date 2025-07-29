# Advanced RDS Example
# This example demonstrates advanced features like monitoring, performance insights, and enhanced security

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

# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AWS managed policy for RDS monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Create an advanced RDS instance with monitoring and security
module "rds_advanced" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "advanced-postgres-db"
  
  # Engine configuration
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.medium"
  
  # Storage
  allocated_storage = 50
  storage_type     = "gp3"
  storage_encrypted = true
  iops             = 3000
  
  # Authentication
  username = "admin"
  password = "your-secure-password-123!"
  
  # Create security group with custom rules
  create_security_group = true
  security_group_name   = "advanced-rds-sg"
  security_group_description = "Security group for advanced RDS PostgreSQL instance"
  
  # Custom security group rules
  security_group_rules = [
    {
      type        = "ingress"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "PostgreSQL access from VPC"
    },
    {
      type        = "ingress"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
      description = "PostgreSQL access from additional VPC range"
    }
  ]
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "advanced-rds-subnet-group"
  
  # Database configuration
  db_name = "myapp_production"
  
  # Backup and maintenance
  backup_retention_period = 30
  backup_window          = "02:00-03:00"
  maintenance_window     = "sun:03:00-sun:04:00"
  
  # High availability
  multi_az = true
  
  # Monitoring and logging
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # CloudWatch Logs
  enable_cloudwatch_logs_exports = ["postgresql", "error", "general"]
  
  # Deletion protection
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "advanced-postgres-final-snapshot"
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "advanced-example"
    Owner       = "terraform"
    CostCenter  = "engineering"
    Backup      = "daily"
  }
} 