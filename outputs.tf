# RDS Module Outputs
# Outputs for both RDS Instances and RDS Clusters

# Security Group Outputs
output "security_group_id" {
  description = "The ID of the security group created for RDS"
  value       = var.create_security_group ? aws_security_group.rds[0].id : null
}

output "security_group_arn" {
  description = "The ARN of the security group created for RDS"
  value       = var.create_security_group ? aws_security_group.rds[0].arn : null
}

output "security_group_name" {
  description = "The name of the security group created for RDS"
  value       = var.create_security_group ? aws_security_group.rds[0].name : null
}

# DB Subnet Group Outputs
output "db_subnet_group_id" {
  description = "The ID of the DB subnet group"
  value       = var.create_db_subnet_group ? aws_db_subnet_group.rds[0].id : null
}

output "db_subnet_group_arn" {
  description = "The ARN of the DB subnet group"
  value       = var.create_db_subnet_group ? aws_db_subnet_group.rds[0].arn : null
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = var.create_db_subnet_group ? aws_db_subnet_group.rds[0].name : null
}

# RDS Instance Outputs
output "db_instance_id" {
  description = "The RDS instance ID"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].id : null
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].arn : null
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].endpoint : null
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].address : null
}

output "db_instance_port" {
  description = "The database port"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].port : null
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].username : null
}

output "db_instance_name" {
  description = "The database name"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].db_name : null
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].status : null
}

output "db_instance_engine" {
  description = "The database engine"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].engine : null
}

output "db_instance_engine_version" {
  description = "The running version of the database"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].engine_version : null
}

output "db_instance_instance_class" {
  description = "The instance type of the RDS instance"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].instance_class : null
}

output "db_instance_allocated_storage" {
  description = "The allocated storage in gigabytes"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].allocated_storage : null
}

output "db_instance_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].storage_type : null
}

output "db_instance_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].multi_az : null
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].availability_zone : null
}

output "db_instance_publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].publicly_accessible : null
}

output "db_instance_backup_retention_period" {
  description = "The backup retention period"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].backup_retention_period : null
}

output "db_instance_backup_window" {
  description = "The backup window"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].backup_window : null
}

output "db_instance_maintenance_window" {
  description = "The maintenance window"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].maintenance_window : null
}

output "db_instance_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].storage_encrypted : null
}

output "db_instance_kms_key_id" {
  description = "The ARN for the KMS encryption key"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].kms_key_id : null
}

output "db_instance_performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].performance_insights_enabled : null
}

output "db_instance_performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].performance_insights_retention_period : null
}

output "db_instance_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].monitoring_interval : null
}

output "db_instance_monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].monitoring_role_arn : null
}

output "db_instance_deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].deletion_protection : null
}

output "db_instance_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].auto_minor_version_upgrade : null
}

output "db_instance_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].allow_major_version_upgrade : null
}

output "db_instance_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  value       = var.create_rds_instance ? aws_db_instance.rds[0].apply_immediately : null
}

# RDS Cluster Outputs
output "db_cluster_id" {
  description = "The RDS cluster ID"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].id : null
}

output "db_cluster_arn" {
  description = "The ARN of the RDS cluster"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].arn : null
}

output "db_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].endpoint : null
}

output "db_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].reader_endpoint : null
}

output "db_cluster_port" {
  description = "The database port"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].port : null
}

output "db_cluster_database_name" {
  description = "The name of the database"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].database_name : null
}

output "db_cluster_master_username" {
  description = "The master username for the database"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].master_username : null
}

output "db_cluster_status" {
  description = "The RDS cluster status"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].status : null
}

output "db_cluster_engine" {
  description = "The database engine"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].engine : null
}

output "db_cluster_engine_version" {
  description = "The running version of the database"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].engine_version : null
}

output "db_cluster_engine_mode" {
  description = "The database engine mode"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].engine_mode : null
}

output "db_cluster_availability_zones" {
  description = "The availability zones of the cluster"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].availability_zones : null
}

output "db_cluster_backup_retention_period" {
  description = "The backup retention period"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].backup_retention_period : null
}

output "db_cluster_preferred_backup_window" {
  description = "The backup window"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].preferred_backup_window : null
}

output "db_cluster_preferred_maintenance_window" {
  description = "The maintenance window"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].preferred_maintenance_window : null
}

output "db_cluster_storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].storage_encrypted : null
}

output "db_cluster_kms_key_id" {
  description = "The ARN for the KMS encryption key"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].kms_key_id : null
}

output "db_cluster_deletion_protection" {
  description = "If the DB cluster should have deletion protection enabled"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].deletion_protection : null
}

output "db_cluster_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB cluster (to be used in a Route 53 Alias record)"
  value       = var.create_rds_cluster ? aws_rds_cluster.rds[0].hosted_zone_id : null
}

# RDS Cluster Instance Outputs
output "db_cluster_instance_ids" {
  description = "List of RDS cluster instance IDs"
  value       = var.create_rds_cluster ? [for instance in aws_rds_cluster_instance.rds : instance.id] : []
}

output "db_cluster_instance_arns" {
  description = "List of RDS cluster instance ARNs"
  value       = var.create_rds_cluster ? [for instance in aws_rds_cluster_instance.rds : instance.arn] : []
}

output "db_cluster_instance_endpoints" {
  description = "List of RDS cluster instance endpoints"
  value       = var.create_rds_cluster ? [for instance in aws_rds_cluster_instance.rds : instance.endpoint] : []
}

output "db_cluster_instance_availability_zones" {
  description = "List of RDS cluster instance availability zones"
  value       = var.create_rds_cluster ? [for instance in aws_rds_cluster_instance.rds : instance.availability_zone] : []
}

output "db_cluster_instance_classes" {
  description = "List of RDS cluster instance classes"
  value       = var.create_rds_cluster ? [for instance in aws_rds_cluster_instance.rds : instance.instance_class] : []
}

output "db_cluster_instance_statuses" {
  description = "List of RDS cluster instance statuses"
  value       = var.create_rds_cluster ? [for instance in aws_rds_cluster_instance.rds : instance.status] : []
}

# CloudWatch Log Group Outputs
output "cloudwatch_log_group_names" {
  description = "List of CloudWatch log group names for RDS instance"
  value       = var.create_rds_instance && length(var.enable_cloudwatch_logs_exports) > 0 ? [for log_group in aws_cloudwatch_log_group.rds_instance : log_group.name] : []
}

output "cloudwatch_log_group_arns" {
  description = "List of CloudWatch log group ARNs for RDS instance"
  value       = var.create_rds_instance && length(var.enable_cloudwatch_logs_exports) > 0 ? [for log_group in aws_cloudwatch_log_group.rds_instance : log_group.arn] : []
}

output "cloudwatch_log_group_names_cluster" {
  description = "List of CloudWatch log group names for RDS cluster"
  value       = var.create_rds_cluster && length(var.cluster_enable_cloudwatch_logs_exports) > 0 ? [for log_group in aws_cloudwatch_log_group.rds_cluster : log_group.name] : []
}

output "cloudwatch_log_group_arns_cluster" {
  description = "List of CloudWatch log group ARNs for RDS cluster"
  value       = var.create_rds_cluster && length(var.cluster_enable_cloudwatch_logs_exports) > 0 ? [for log_group in aws_cloudwatch_log_group.rds_cluster : log_group.arn] : []
}

# Connection Information
output "connection_info" {
  description = "Connection information for the database"
  value = {
    endpoint = var.create_rds_instance ? aws_db_instance.rds[0].endpoint : (var.create_rds_cluster ? aws_rds_cluster.rds[0].endpoint : null)
    port     = var.create_rds_instance ? aws_db_instance.rds[0].port : (var.create_rds_cluster ? aws_rds_cluster.rds[0].port : null)
    username = var.create_rds_instance ? aws_db_instance.rds[0].username : (var.create_rds_cluster ? aws_rds_cluster.rds[0].master_username : null)
    database = var.create_rds_instance ? aws_db_instance.rds[0].db_name : (var.create_rds_cluster ? aws_rds_cluster.rds[0].database_name : null)
  }
  sensitive = false
} 