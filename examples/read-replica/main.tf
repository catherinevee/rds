# Read Replica RDS Example
# This example demonstrates how to create an RDS instance with read replicas

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

# Create the primary RDS instance
module "primary_db" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "primary-database"
  
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
  db_name = "primary_db"
  
  # Create security group
  create_security_group = true
  security_group_name   = "primary-db-sg"
  security_group_description = "Security group for primary RDS instance"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "primary-db-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 7
  backup_window          = "02:00-03:00"
  maintenance_window     = "sun:03:00-sun:04:00"
  
  # High availability
  multi_az = true
  
  # Monitoring and logging
  monitoring_interval = 60
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # CloudWatch Logs
  enable_cloudwatch_logs_exports = ["error", "general", "slow_query"]
  
  # Security
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "primary-database-final-snapshot"
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "read-replica-example"
    Owner       = "terraform"
    Role        = "primary"
  }
}

# Create read replica 1
module "read_replica_1" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "read-replica-1"
  
  # Engine configuration (must match primary)
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.medium"
  
  # Storage
  allocated_storage = 100
  storage_type     = "gp3"
  storage_encrypted = true
  iops             = 3000
  
  # Authentication (read replicas inherit from source)
  username = "admin"
  password = "your-secure-password-123!"
  
  # Read replica configuration
  replicate_source_db = module.primary_db.db_instance_id
  
  # Create security group
  create_security_group = true
  security_group_name   = "read-replica-1-sg"
  security_group_description = "Security group for read replica 1"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "read-replica-1-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  # High availability
  multi_az = false  # Read replicas typically don't need Multi-AZ
  
  # Monitoring and logging
  monitoring_interval = 60
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # CloudWatch Logs
  enable_cloudwatch_logs_exports = ["error", "general", "slow_query"]
  
  # Security
  deletion_protection = false  # Read replicas can be deleted more easily
  skip_final_snapshot = true
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "read-replica-example"
    Owner       = "terraform"
    Role        = "read-replica"
    ReplicaOf   = "primary-database"
  }
}

# Create read replica 2
module "read_replica_2" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "read-replica-2"
  
  # Engine configuration (must match primary)
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.medium"
  
  # Storage
  allocated_storage = 100
  storage_type     = "gp3"
  storage_encrypted = true
  iops             = 3000
  
  # Authentication (read replicas inherit from source)
  username = "admin"
  password = "your-secure-password-123!"
  
  # Read replica configuration
  replicate_source_db = module.primary_db.db_instance_id
  
  # Create security group
  create_security_group = true
  security_group_name   = "read-replica-2-sg"
  security_group_description = "Security group for read replica 2"
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "read-replica-2-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 7
  backup_window          = "04:00-05:00"
  maintenance_window     = "sun:05:00-sun:06:00"
  
  # High availability
  multi_az = false  # Read replicas typically don't need Multi-AZ
  
  # Monitoring and logging
  monitoring_interval = 60
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # CloudWatch Logs
  enable_cloudwatch_logs_exports = ["error", "general", "slow_query"]
  
  # Security
  deletion_protection = false  # Read replicas can be deleted more easily
  skip_final_snapshot = true
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "read-replica-example"
    Owner       = "terraform"
    Role        = "read-replica"
    ReplicaOf   = "primary-database"
  }
}

# Outputs
output "primary_database_endpoint" {
  description = "Primary database connection endpoint"
  value       = module.primary_db.db_instance_endpoint
}

output "primary_database_port" {
  description = "Primary database port"
  value       = module.primary_db.db_instance_port
}

output "read_replica_1_endpoint" {
  description = "Read replica 1 connection endpoint"
  value       = module.read_replica_1.db_instance_endpoint
}

output "read_replica_2_endpoint" {
  description = "Read replica 2 connection endpoint"
  value       = module.read_replica_2.db_instance_endpoint
}

output "primary_database_arn" {
  description = "Primary database ARN"
  value       = module.primary_db.db_instance_arn
}

output "read_replica_1_arn" {
  description = "Read replica 1 ARN"
  value       = module.read_replica_1.db_instance_arn
}

output "read_replica_2_arn" {
  description = "Read replica 2 ARN"
  value       = module.read_replica_2.db_instance_arn
} 