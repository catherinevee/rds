# Outputs for Advanced RDS Example

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds_advanced.db_instance_endpoint
}

output "db_instance_port" {
  description = "The database port"
  value       = module.rds_advanced.db_instance_port
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.rds_advanced.db_instance_username
}

output "db_instance_name" {
  description = "The database name"
  value       = module.rds_advanced.db_instance_name
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.rds_advanced.db_instance_status
}

output "db_instance_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  value       = module.rds_advanced.db_instance_multi_az
}

output "db_instance_performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  value       = module.rds_advanced.db_instance_performance_insights_enabled
}

output "db_instance_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
  value       = module.rds_advanced.db_instance_monitoring_interval
}

output "db_instance_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  value       = module.rds_advanced.db_instance_storage_encrypted
}

output "db_instance_deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  value       = module.rds_advanced.db_instance_deletion_protection
}

output "security_group_id" {
  description = "The ID of the security group created for RDS"
  value       = module.rds_advanced.security_group_id
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = module.rds_advanced.db_subnet_group_name
}

output "cloudwatch_log_group_names" {
  description = "List of CloudWatch log group names for RDS instance"
  value       = module.rds_advanced.cloudwatch_log_group_names
}

output "connection_info" {
  description = "Connection information for the database"
  value       = module.rds_advanced.connection_info
}

output "monitoring_role_arn" {
  description = "The ARN of the IAM role for RDS monitoring"
  value       = aws_iam_role.rds_monitoring.arn
} 