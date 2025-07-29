# RDS Module Variables
# Supports both RDS Instances and RDS Clusters

# General Configuration
variable "create_rds_instance" {
  description = "Whether to create an RDS instance"
  type        = bool
  default     = false
}

variable "create_rds_cluster" {
  description = "Whether to create an RDS cluster (Aurora)"
  type        = bool
  default     = false
}

variable "identifier" {
  description = "The name of the RDS instance/cluster"
  type        = string

  validation {
    condition     = length(var.identifier) > 0 && length(var.identifier) <= 63
    error_message = "Identifier must be between 1 and 63 characters."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

# Engine Configuration
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"

  validation {
    condition     = contains(["mysql", "postgres", "mariadb", "oracle-ee", "oracle-se", "oracle-se1", "oracle-se2", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web", "aurora", "aurora-mysql", "aurora-postgresql"], var.engine)
    error_message = "Engine must be a valid RDS engine type."
  }
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = can(regex("^db\\.[a-z0-9]+\\.[a-z0-9]+$", var.instance_class))
    error_message = "Instance class must be a valid RDS instance type."
  }
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 65536
    error_message = "Allocated storage must be between 20 and 65536 GB."
  }
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  type        = string
  default     = "gp2"

  validation {
    condition     = contains(["standard", "gp2", "gp3", "io1"], var.storage_type)
    error_message = "Storage type must be one of: standard, gp2, gp3, io1."
  }
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = null

  validation {
    condition     = var.iops == null || (var.iops >= 1000 && var.iops <= 80000)
    error_message = "IOPS must be between 1000 and 80000."
  }
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN"
  type        = string
  default     = null
}

# Network Configuration
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group"
  type        = string
  default     = null
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "The AZ for the RDS instance"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

# Authentication
variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"

  validation {
    condition     = length(var.username) >= 1 && length(var.username) <= 16
    error_message = "Username must be between 1 and 16 characters."
  }
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = null
  sensitive   = true
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = false
}

variable "master_user_secret_kms_key_id" {
  description = "The key to use for the master user secret"
  type        = string
  default     = null
}

# Database Configuration
variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = null
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = null
}

variable "option_group_name" {
  description = "Name of the DB option group to associate"
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "The character set name to use for DB encoding in Oracle instances"
  type        = string
  default     = null
}

# Backup and Maintenance
variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days."
  }
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled"
  type        = string
  default     = "03:00-04:00"

  validation {
    condition     = can(regex("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]-([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", var.backup_window))
    error_message = "Backup window must be in format HH:MM-HH:MM."
  }
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'"
  type        = string
  default     = "sun:04:00-sun:05:00"

  validation {
    condition     = can(regex("^(mon|tue|wed|thu|fri|sat|sun):([0-1]?[0-9]|2[0-3]):[0-5][0-9]-(mon|tue|wed|thu|fri|sat|sun):([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", var.maintenance_window))
    error_message = "Maintenance window must be in format ddd:hh24:mi-ddd:hh24:mi."
  }
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

# Monitoring and Logging
variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "Monitoring interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = string
  default     = null
}

variable "enable_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for log in var.enable_cloudwatch_logs_exports : contains(["audit", "error", "general", "slowquery"], log)
    ])
    error_message = "CloudWatch log exports must be one of: audit, error, general, slowquery."
  }
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data"
  type        = number
  default     = 7

  validation {
    condition     = contains([7, 731], var.performance_insights_retention_period)
    error_message = "Performance insights retention period must be either 7 or 731 days."
  }
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

# Deletion Protection
variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted"
  type        = string
  default     = null
}

# RDS Cluster Specific Variables (Aurora)
variable "cluster_engine_mode" {
  description = "The database engine mode. Valid values: provisioned, serverless, parallelquery, global, multimaster"
  type        = string
  default     = "provisioned"

  validation {
    condition     = contains(["provisioned", "serverless", "parallelquery", "global", "multimaster"], var.cluster_engine_mode)
    error_message = "Cluster engine mode must be one of: provisioned, serverless, parallelquery, global, multimaster."
  }
}

variable "cluster_instances" {
  description = "List of cluster instances to create"
  type = list(object({
    identifier     = string
    instance_class = string
    publicly_accessible = optional(bool, false)
    availability_zone = optional(string)
    promotion_tier = optional(number, 0)
    auto_minor_version_upgrade = optional(bool, true)
    monitoring_interval = optional(number, 0)
    monitoring_role_arn = optional(string)
    performance_insights_enabled = optional(bool, false)
    performance_insights_kms_key_id = optional(string)
    tags = optional(map(string), {})
  }))
  default = []
}

variable "cluster_availability_zones" {
  description = "List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created"
  type        = list(string)
  default     = []
}

variable "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = null
}

variable "cluster_master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "cluster_master_password" {
  description = "Password for the master DB user"
  type        = string
  default     = null
  sensitive   = true
}

variable "cluster_backup_retention_period" {
  description = "The backup retention period in days"
  type        = number
  default     = 7
}

variable "cluster_preferred_backup_window" {
  description = "The daily time range during which automated backups are created if they are enabled"
  type        = string
  default     = "03:00-04:00"
}

variable "cluster_preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "cluster_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = null
}

variable "cluster_vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the cluster"
  type        = list(string)
  default     = []
}

variable "cluster_db_subnet_group_name" {
  description = "A DB subnet group to associate with this DB cluster"
  type        = string
  default     = null
}

variable "cluster_storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "cluster_kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
  default     = null
}

variable "cluster_deletion_protection" {
  description = "If the DB cluster should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "cluster_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  type        = bool
  default     = false
}

variable "cluster_final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB cluster is deleted"
  type        = string
  default     = null
}

variable "cluster_enable_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for log in var.cluster_enable_cloudwatch_logs_exports : contains(["audit", "error", "general", "slowquery", "postgresql"], log)
    ])
    error_message = "Cluster CloudWatch log exports must be one of: audit, error, general, slowquery, postgresql."
  }
}

# Security Group Configuration
variable "create_security_group" {
  description = "Whether to create a security group for the RDS instance/cluster"
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for RDS instance/cluster"
}

variable "security_group_rules" {
  description = "List of security group rules to create"
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
    source_security_group_id = optional(string)
    description = optional(string)
  }))
  default = []
}

# Subnet Group Configuration
variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of VPC subnet IDs for the DB subnet group"
  type        = list(string)
  default     = []
}

variable "subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
  default     = null
}

variable "subnet_group_description" {
  description = "Description of the DB subnet group"
  type        = string
  default     = "Database subnet group for RDS"
} 