# Outputs for Basic RDS Example

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds_basic.db_instance_endpoint
}

output "db_instance_port" {
  description = "The database port"
  value       = module.rds_basic.db_instance_port
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.rds_basic.db_instance_username
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.rds_basic.db_instance_status
}

output "security_group_id" {
  description = "The ID of the security group created for RDS"
  value       = module.rds_basic.security_group_id
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = module.rds_basic.db_subnet_group_name
}

output "connection_info" {
  description = "Connection information for the database"
  value       = module.rds_basic.connection_info
} 