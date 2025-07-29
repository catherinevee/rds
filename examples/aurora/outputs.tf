# Outputs for Aurora Cluster Example

output "db_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora_cluster.db_cluster_endpoint
}

output "db_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.aurora_cluster.db_cluster_reader_endpoint
}

output "db_cluster_port" {
  description = "The database port"
  value       = module.aurora_cluster.db_cluster_port
}

output "db_cluster_master_username" {
  description = "The master username for the database"
  value       = module.aurora_cluster.db_cluster_master_username
}

output "db_cluster_status" {
  description = "The RDS cluster status"
  value       = module.aurora_cluster.db_cluster_status
}

output "db_cluster_instance_ids" {
  description = "List of RDS cluster instance IDs"
  value       = module.aurora_cluster.db_cluster_instance_ids
}

output "db_cluster_instance_endpoints" {
  description = "List of RDS cluster instance endpoints"
  value       = module.aurora_cluster.db_cluster_instance_endpoints
}

output "security_group_id" {
  description = "The ID of the security group created for RDS"
  value       = module.aurora_cluster.security_group_id
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = module.aurora_cluster.db_subnet_group_name
}

output "connection_info" {
  description = "Connection information for the database"
  value       = module.aurora_cluster.connection_info
} 