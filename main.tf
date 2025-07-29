# Custom RDS Module using AWS Provider
# Supports both RDS Instances and RDS Clusters (Aurora)

# Data sources for default values
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Local values for common configurations
locals {
  # Common tags
  common_tags = merge(
    {
      Name        = var.identifier
      Environment = lookup(var.tags, "Environment", "dev")
      ManagedBy   = "terraform"
    },
    var.tags
  )

  # Security group name
  security_group_name = var.security_group_name != null ? var.security_group_name : "${var.identifier}-sg"

  # Subnet group name
  subnet_group_name = var.subnet_group_name != null ? var.subnet_group_name : "${var.identifier}-subnet-group"

  # Default port based on engine
  default_port = {
    mysql             = 3306
    postgres          = 5432
    mariadb           = 3306
    oracle-ee         = 1521
    oracle-se         = 1521
    oracle-se1        = 1521
    oracle-se2        = 1521
    sqlserver-ee      = 1433
    sqlserver-se      = 1433
    sqlserver-ex      = 1433
    sqlserver-web     = 1433
    aurora            = 3306
    aurora-mysql      = 3306
    aurora-postgresql = 5432
  }

  db_port = var.port != null ? var.port : local.default_port[var.engine]
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  count = var.create_security_group ? 1 : 0

  name        = local.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_security_group_ids != [] ? data.aws_security_group.existing[0].vpc_id : null

  tags = merge(
    {
      Name = local.security_group_name
    },
    local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Data source to get VPC ID from existing security groups
data "aws_security_group" "existing" {
  count = var.create_security_group && var.vpc_security_group_ids != [] ? 1 : 0
  id    = var.vpc_security_group_ids[0]
}

# Security Group Rules
resource "aws_security_group_rule" "rds" {
  for_each = {
    for rule in var.security_group_rules : "${rule.type}-${rule.from_port}-${rule.to_port}-${rule.protocol}" => rule
  }

  security_group_id = aws_security_group.rds[0].id
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  description       = lookup(each.value, "description", null)
}

# Default security group rule for database access
resource "aws_security_group_rule" "rds_default_ingress" {
  count = var.create_security_group ? 1 : 0

  security_group_id = aws_security_group.rds[0].id
  type              = "ingress"
  from_port         = local.db_port
  to_port           = local.db_port
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description       = "Database access from private networks"
}

# Egress rule for security group
resource "aws_security_group_rule" "rds_egress" {
  count = var.create_security_group ? 1 : 0

  security_group_id = aws_security_group.rds[0].id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# DB Subnet Group
resource "aws_db_subnet_group" "rds" {
  count = var.create_db_subnet_group ? 1 : 0

  name        = local.subnet_group_name
  description = var.subnet_group_description
  subnet_ids  = var.subnet_ids

  tags = merge(
    {
      Name = local.subnet_group_name
    },
    local.common_tags
  )
}

# RDS Instance
resource "aws_db_instance" "rds" {
  count = var.create_rds_instance ? 1 : 0

  identifier = var.identifier

  # Engine configuration
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  iops                 = var.iops
  storage_encrypted    = var.storage_encrypted
  kms_key_id           = var.kms_key_id

  # Network configuration
  vpc_security_group_ids = concat(
    var.create_security_group ? [aws_security_group.rds[0].id] : [],
    var.vpc_security_group_ids
  )
  db_subnet_group_name   = var.create_db_subnet_group ? aws_db_subnet_group.rds[0].name : var.db_subnet_group_name
  port                   = local.db_port
  publicly_accessible    = var.publicly_accessible
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az

  # Authentication
  username                    = var.username
  password                    = var.password
  manage_master_user_password = var.manage_master_user_password
  master_user_secret_kms_key_id = var.master_user_secret_kms_key_id

  # Database configuration
  db_name  = var.db_name
  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name
  character_set_name   = var.character_set_name

  # Backup and maintenance
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately      = var.apply_immediately

  # Monitoring and logging
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn
  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id = var.performance_insights_kms_key_id

  # Deletion protection
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_security_group.rds,
    aws_db_subnet_group.rds
  ]
}

# RDS Cluster (Aurora)
resource "aws_rds_cluster" "rds" {
  count = var.create_rds_cluster ? 1 : 0

  cluster_identifier = var.identifier

  # Engine configuration
  engine               = var.engine
  engine_version       = var.engine_version
  engine_mode          = var.cluster_engine_mode

  # Network configuration
  vpc_security_group_ids = concat(
    var.create_security_group ? [aws_security_group.rds[0].id] : [],
    var.cluster_vpc_security_group_ids
  )
  db_subnet_group_name = var.create_db_subnet_group ? aws_db_subnet_group.rds[0].name : var.cluster_db_subnet_group_name
  port                 = var.cluster_port != null ? var.cluster_port : local.db_port
  availability_zones   = var.cluster_availability_zones

  # Authentication
  master_username = var.cluster_master_username
  master_password = var.cluster_master_password

  # Database configuration
  database_name = var.cluster_database_name

  # Backup and maintenance
  backup_retention_period = var.cluster_backup_retention_period
  preferred_backup_window = var.cluster_preferred_backup_window
  preferred_maintenance_window = var.cluster_preferred_maintenance_window

  # Storage and encryption
  storage_encrypted = var.cluster_storage_encrypted
  kms_key_id        = var.cluster_kms_key_id

  # Deletion protection
  deletion_protection = var.cluster_deletion_protection
  skip_final_snapshot = var.cluster_skip_final_snapshot
  final_snapshot_identifier = var.cluster_final_snapshot_identifier

  # Logging
  # Note: enable_cloudwatch_logs_exports is not supported for RDS clusters in this provider version

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_security_group.rds,
    aws_db_subnet_group.rds
  ]
}

# RDS Cluster Instances
resource "aws_rds_cluster_instance" "rds" {
  for_each = {
    for instance in var.cluster_instances : instance.identifier => instance
  }

  cluster_identifier = aws_rds_cluster.rds[0].id
  identifier         = each.value.identifier
  instance_class     = each.value.instance_class
  engine             = var.engine

  # Network configuration
  publicly_accessible = lookup(each.value, "publicly_accessible", false)
  availability_zone   = lookup(each.value, "availability_zone", null)

  # Instance configuration
  promotion_tier = lookup(each.value, "promotion_tier", 0)
  auto_minor_version_upgrade = lookup(each.value, "auto_minor_version_upgrade", true)

  # Monitoring
  monitoring_interval = lookup(each.value, "monitoring_interval", 0)
  monitoring_role_arn = lookup(each.value, "monitoring_role_arn", null)

  # Performance Insights
  performance_insights_enabled = lookup(each.value, "performance_insights_enabled", false)
  performance_insights_kms_key_id = lookup(each.value, "performance_insights_kms_key_id", null)

  tags = merge(
    local.common_tags,
    lookup(each.value, "tags", {})
  )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_rds_cluster.rds]
}

# CloudWatch Log Groups for RDS Instance
resource "aws_cloudwatch_log_group" "rds_instance" {
  for_each = var.create_rds_instance && length(var.enable_cloudwatch_logs_exports) > 0 ? toset(var.enable_cloudwatch_logs_exports) : []

  name              = "/aws/rds/instance/${var.identifier}/${each.value}"
  retention_in_days = 7

  tags = local.common_tags
}

# CloudWatch Log Groups for RDS Cluster
resource "aws_cloudwatch_log_group" "rds_cluster" {
  for_each = var.create_rds_cluster && length(var.cluster_enable_cloudwatch_logs_exports) > 0 ? toset(var.cluster_enable_cloudwatch_logs_exports) : []

  name              = "/aws/rds/cluster/${var.identifier}/${each.value}"
  retention_in_days = 7

  tags = local.common_tags
} 