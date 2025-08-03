# Enterprise RDS Example
# This example demonstrates enterprise-grade RDS configuration with maximum security and compliance

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

# KMS Key for encryption
resource "aws_kms_key" "rds_encryption" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  
  tags = {
    Environment = "production"
    Project     = "enterprise-example"
    Purpose     = "rds-encryption"
  }
}

# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "enterprise-rds-monitoring-role"

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

# Create an enterprise-grade RDS instance
module "enterprise_db" {
  source = "../../"

  # Basic configuration
  create_rds_instance = true
  identifier         = "enterprise-production-db"
  
  # Engine configuration
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.r6g.xlarge"
  
  # Storage
  allocated_storage = 500
  storage_type     = "gp3"
  storage_encrypted = true
  iops             = 10000
  
  # Authentication
  username = "enterprise_admin"
  password = "your-very-secure-password-123!"
  
  # Database configuration
  db_name = "enterprise_production"
  port    = 5432
  
  # Create security group with strict rules
  create_security_group = true
  security_group_name   = "enterprise-rds-sg"
  security_group_description = "Enterprise security group for RDS with strict access controls"
  
  # Strict security group rules
  security_group_rules = [
    {
      type        = "ingress"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "PostgreSQL access from VPC only"
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.default.ids
  subnet_group_name      = "enterprise-rds-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 35
  backup_window          = "01:00-02:00"
  maintenance_window     = "sun:02:00-sun:03:00"
  
  # High availability
  multi_az = true
  
  # Enhanced monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 31
  performance_insights_kms_key_id = aws_kms_key.rds_encryption.arn
  
  # CloudWatch Logs
  enable_cloudwatch_logs_exports = ["postgresql", "error", "general", "slow_query"]
  
  # Security
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "enterprise-production-final-snapshot"
  
  # Auto scaling and upgrades
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  apply_immediately = false
  
  # KMS encryption
  kms_key_id = aws_kms_key.rds_encryption.arn
  
  # Tags for enterprise governance
  tags = {
    Environment = "production"
    Project     = "enterprise-example"
    Owner       = "enterprise-team"
    CostCenter  = "database-operations"
    DataClassification = "confidential"
    Compliance  = "SOX-HIPAA-PCI"
    BackupRetention = "35-days"
    Encryption  = "enabled"
    Monitoring  = "enhanced"
    PerformanceInsights = "enabled"
    MultiAZ     = "enabled"
    DeletionProtection = "enabled"
  }
}

# CloudWatch Alarms for monitoring
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "enterprise-db-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors RDS CPU utilization"
  
  dimensions = {
    DBInstanceIdentifier = module.enterprise_db.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  alarm_name          = "enterprise-db-free-storage-space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10000000000"  # 10 GB
  alarm_description   = "This metric monitors RDS free storage space"
  
  dimensions = {
    DBInstanceIdentifier = module.enterprise_db.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "database_connections" {
  alarm_name          = "enterprise-db-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "100"
  alarm_description   = "This metric monitors RDS database connections"
  
  dimensions = {
    DBInstanceIdentifier = module.enterprise_db.db_instance_id
  }
}

# Outputs
output "enterprise_database_endpoint" {
  description = "Enterprise database connection endpoint"
  value       = module.enterprise_db.db_instance_endpoint
  sensitive   = true
}

output "enterprise_database_port" {
  description = "Enterprise database port"
  value       = module.enterprise_db.db_instance_port
}

output "enterprise_database_name" {
  description = "Enterprise database name"
  value       = module.enterprise_db.db_instance_name
  sensitive   = true
}

output "enterprise_database_username" {
  description = "Enterprise database username"
  value       = module.enterprise_db.db_instance_username
  sensitive   = true
}

output "enterprise_database_arn" {
  description = "Enterprise database ARN"
  value       = module.enterprise_db.db_instance_arn
}

output "enterprise_kms_key_arn" {
  description = "KMS key ARN used for encryption"
  value       = aws_kms_key.rds_encryption.arn
} 