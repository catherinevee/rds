# AWS RDS Terraform Module

A comprehensive Terraform module for creating AWS RDS (Relational Database Service) resources. This module supports both RDS instances and RDS clusters (Aurora), providing a flexible and secure way to deploy database infrastructure.

## Features

- **Dual Support**: Create either RDS instances or RDS clusters (Aurora)
- **Security**: Built-in security groups with configurable rules
- **Networking**: Automatic subnet group creation and VPC integration
- **Monitoring**: CloudWatch logs and Performance Insights support
- **Encryption**: KMS encryption for data at rest
- **Backup**: Configurable backup retention and maintenance windows
- **High Availability**: Multi-AZ deployment support
- **Compliance**: Deletion protection and audit logging

## Supported Engines

### RDS Instances
- MySQL
- PostgreSQL
- MariaDB
- Oracle (EE, SE, SE1, SE2)
- SQL Server (EE, SE, EX, Web)

### RDS Clusters (Aurora)
- Aurora MySQL
- Aurora PostgreSQL

## Usage

### Basic RDS Instance

```hcl
module "rds" {
  source = "./rds"

  # Basic configuration
  create_rds_instance = true
  identifier         = "my-database"
  
  # Engine configuration
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  # Storage
  allocated_storage = 20
  storage_type     = "gp2"
  storage_encrypted = true
  
  # Authentication
  username = "admin"
  password = "your-secure-password"
  
  # Network
  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name   = "my-subnet-group"
  
  # Backup and maintenance
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### RDS Cluster (Aurora)

```hcl
module "aurora" {
  source = "./rds"

  # Basic configuration
  create_rds_cluster = true
  identifier         = "my-aurora-cluster"
  
  # Engine configuration
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.1"
  cluster_engine_mode = "provisioned"
  
  # Authentication
  cluster_master_username = "admin"
  cluster_master_password = "your-secure-password"
  
  # Network
  cluster_vpc_security_group_ids = ["sg-12345678"]
  cluster_db_subnet_group_name   = "my-subnet-group"
  
  # Cluster instances
  cluster_instances = [
    {
      identifier     = "primary"
      instance_class = "db.r6g.large"
      availability_zone = "us-west-2a"
    },
    {
      identifier     = "replica"
      instance_class = "db.r6g.large"
      availability_zone = "us-west-2b"
    }
  ]
  
  # Backup and maintenance
  cluster_backup_retention_period = 7
  cluster_preferred_backup_window = "03:00-04:00"
  cluster_preferred_maintenance_window = "sun:04:00-sun:05:00"
  
  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### With Custom Security Group

```hcl
module "rds" {
  source = "./rds"

  create_rds_instance = true
  identifier         = "my-database"
  
  # Engine configuration
  engine         = "postgres"
  instance_class = "db.t3.micro"
  
  # Create custom security group
  create_security_group = true
  security_group_name   = "my-rds-sg"
  security_group_description = "Security group for RDS PostgreSQL"
  
  # Custom security group rules
  security_group_rules = [
    {
      type        = "ingress"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "PostgreSQL access from VPC"
    }
  ]
  
  # Create subnet group
  create_db_subnet_group = true
  subnet_ids             = ["subnet-12345678", "subnet-87654321"]
  
  # Authentication
  username = "admin"
  password = "your-secure-password"
  
  tags = {
    Environment = "production"
  }
}
```

### With Performance Insights and Monitoring

```hcl
module "rds" {
  source = "./rds"

  create_rds_instance = true
  identifier         = "my-monitored-database"
  
  # Engine configuration
  engine         = "mysql"
  instance_class = "db.t3.micro"
  
  # Monitoring
  monitoring_interval = 60
  monitoring_role_arn = "arn:aws:iam::123456789012:role/rds-monitoring-role"
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # CloudWatch Logs
  enable_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  
  # Network
  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name   = "my-subnet-group"
  
  # Authentication
  username = "admin"
  password = "your-secure-password"
  
  tags = {
    Environment = "production"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.13.0 |
| aws | = 6.2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | = 6.2.0 |

## Inputs

### General Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_rds_instance | Whether to create an RDS instance | `bool` | `false` | no |
| create_rds_cluster | Whether to create an RDS cluster (Aurora) | `bool` | `false` | no |
| identifier | The name of the RDS instance/cluster | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

### Engine Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| engine | The database engine to use | `string` | `"mysql"` | no |
| engine_version | The engine version to use | `string` | `null` | no |
| instance_class | The instance type of the RDS instance | `string` | `"db.t3.micro"` | no |
| allocated_storage | The allocated storage in gigabytes | `number` | `20` | no |
| storage_type | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD) | `string` | `"gp2"` | no |
| iops | The amount of provisioned IOPS. Setting this implies a storage_type of 'io1' | `number` | `null` | no |
| storage_encrypted | Specifies whether the DB instance is encrypted | `bool` | `true` | no |
| kms_key_id | The ARN for the KMS encryption key | `string` | `null` | no |

### Network Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_security_group_ids | List of VPC security groups to associate | `list(string)` | `[]` | no |
| db_subnet_group_name | Name of DB subnet group | `string` | `null` | no |
| port | The port on which the DB accepts connections | `number` | `null` | no |
| publicly_accessible | Bool to control if instance is publicly accessible | `bool` | `false` | no |
| availability_zone | The AZ for the RDS instance | `string` | `null` | no |
| multi_az | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |

### Authentication

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| username | Username for the master DB user | `string` | `"admin"` | no |
| password | Password for the master DB user | `string` | `null` | no |
| manage_master_user_password | Set to true to allow RDS to manage the master user password in Secrets Manager | `bool` | `false` | no |
| master_user_secret_kms_key_id | The key to use for the master user secret | `string` | `null` | no |

### Database Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db_name | The name of the database to create when the DB instance is created | `string` | `null` | no |
| parameter_group_name | Name of the DB parameter group to associate | `string` | `null` | no |
| option_group_name | Name of the DB option group to associate | `string` | `null` | no |
| character_set_name | The character set name to use for DB encoding in Oracle instances | `string` | `null` | no |

### Backup and Maintenance

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup_retention_period | The days to retain backups for | `number` | `7` | no |
| backup_window | The daily time range during which automated backups are created | `string` | `"03:00-04:00"` | no |
| maintenance_window | The window to perform maintenance in | `string` | `"sun:04:00-sun:05:00"` | no |
| auto_minor_version_upgrade | Indicates that minor engine upgrades will be applied automatically | `bool` | `true` | no |
| allow_major_version_upgrade | Indicates that major version upgrades are allowed | `bool` | `false` | no |
| apply_immediately | Specifies whether any database modifications are applied immediately | `bool` | `false` | no |

### Monitoring and Logging

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| monitoring_interval | The interval, in seconds, between points when Enhanced Monitoring metrics are collected | `number` | `0` | no |
| monitoring_role_arn | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics | `string` | `null` | no |
| enable_cloudwatch_logs_exports | List of log types to enable for exporting to CloudWatch logs | `list(string)` | `[]` | no |
| performance_insights_enabled | Specifies whether Performance Insights are enabled | `bool` | `false` | no |
| performance_insights_retention_period | The amount of time in days to retain Performance Insights data | `number` | `7` | no |
| performance_insights_kms_key_id | The ARN for the KMS key to encrypt Performance Insights data | `string` | `null` | no |

### Deletion Protection

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deletion_protection | The database can't be deleted when this value is set to true | `bool` | `false` | no |
| skip_final_snapshot | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | `false` | no |
| final_snapshot_identifier | The name of your final DB snapshot when this DB instance is deleted | `string` | `null` | no |

### Security Group Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_security_group | Whether to create a security group for the RDS instance/cluster | `bool` | `true` | no |
| security_group_name | Name of the security group | `string` | `null` | no |
| security_group_description | Description of the security group | `string` | `"Security group for RDS instance/cluster"` | no |
| security_group_rules | List of security group rules to create | `list(object)` | `[]` | no |

### Subnet Group Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_db_subnet_group | Whether to create a database subnet group | `bool` | `false` | no |
| subnet_ids | List of VPC subnet IDs for the DB subnet group | `list(string)` | `[]` | no |
| subnet_group_name | Name of the DB subnet group | `string` | `null` | no |
| subnet_group_description | Description of the DB subnet group | `string` | `"Database subnet group for RDS"` | no |

## Outputs

### Security Group Outputs

| Name | Description |
|------|-------------|
| security_group_id | The ID of the security group created for RDS |
| security_group_arn | The ARN of the security group created for RDS |
| security_group_name | The name of the security group created for RDS |

### DB Subnet Group Outputs

| Name | Description |
|------|-------------|
| db_subnet_group_id | The ID of the DB subnet group |
| db_subnet_group_arn | The ARN of the DB subnet group |
| db_subnet_group_name | The name of the DB subnet group |

### RDS Instance Outputs

| Name | Description |
|------|-------------|
| db_instance_id | The RDS instance ID |
| db_instance_arn | The ARN of the RDS instance |
| db_instance_endpoint | The connection endpoint |
| db_instance_address | The address of the RDS instance |
| db_instance_port | The database port |
| db_instance_username | The master username for the database |
| db_instance_name | The database name |
| db_instance_status | The RDS instance status |
| db_instance_engine | The database engine |
| db_instance_engine_version | The running version of the database |
| db_instance_instance_class | The instance type of the RDS instance |
| db_instance_allocated_storage | The allocated storage in gigabytes |
| db_instance_storage_type | The storage type |
| db_instance_multi_az | Specifies if the RDS instance is multi-AZ |
| db_instance_availability_zone | The availability zone of the RDS instance |
| db_instance_publicly_accessible | Bool to control if instance is publicly accessible |
| db_instance_backup_retention_period | The backup retention period |
| db_instance_backup_window | The backup window |
| db_instance_maintenance_window | The maintenance window |
| db_instance_storage_encrypted | Specifies whether the DB instance is encrypted |
| db_instance_kms_key_id | The ARN for the KMS encryption key |
| db_instance_performance_insights_enabled | Specifies whether Performance Insights are enabled |
| db_instance_performance_insights_retention_period | The amount of time in days to retain Performance Insights data |
| db_instance_monitoring_interval | The interval, in seconds, between points when Enhanced Monitoring metrics are collected |
| db_instance_monitoring_role_arn | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics |
| db_instance_deletion_protection | The database can't be deleted when this value is set to true |
| db_instance_auto_minor_version_upgrade | Indicates that minor engine upgrades will be applied automatically |
| db_instance_allow_major_version_upgrade | Indicates that major version upgrades are allowed |
| db_instance_apply_immediately | Specifies whether any database modifications are applied immediately |

### RDS Cluster Outputs

| Name | Description |
|------|-------------|
| db_cluster_id | The RDS cluster ID |
| db_cluster_arn | The ARN of the RDS cluster |
| db_cluster_endpoint | The cluster endpoint |
| db_cluster_reader_endpoint | The cluster reader endpoint |
| db_cluster_port | The database port |
| db_cluster_database_name | The name of the database |
| db_cluster_master_username | The master username for the database |
| db_cluster_status | The RDS cluster status |
| db_cluster_engine | The database engine |
| db_cluster_engine_version | The running version of the database |
| db_cluster_engine_mode | The database engine mode |
| db_cluster_availability_zones | The availability zones of the cluster |
| db_cluster_backup_retention_period | The backup retention period |
| db_cluster_preferred_backup_window | The backup window |
| db_cluster_preferred_maintenance_window | The maintenance window |
| db_cluster_storage_encrypted | Specifies whether the DB cluster is encrypted |
| db_cluster_kms_key_id | The ARN for the KMS encryption key |
| db_cluster_deletion_protection | If the DB cluster should have deletion protection enabled |
| db_cluster_hosted_zone_id | The canonical hosted zone ID of the DB cluster |

### RDS Cluster Instance Outputs

| Name | Description |
|------|-------------|
| db_cluster_instance_ids | List of RDS cluster instance IDs |
| db_cluster_instance_arns | List of RDS cluster instance ARNs |
| db_cluster_instance_endpoints | List of RDS cluster instance endpoints |
| db_cluster_instance_availability_zones | List of RDS cluster instance availability zones |
| db_cluster_instance_classes | List of RDS cluster instance classes |
| db_cluster_instance_statuses | List of RDS cluster instance statuses |

### CloudWatch Log Group Outputs

| Name | Description |
|------|-------------|
| cloudwatch_log_group_names | List of CloudWatch log group names for RDS instance |
| cloudwatch_log_group_arns | List of CloudWatch log group ARNs for RDS instance |
| cloudwatch_log_group_names_cluster | List of CloudWatch log group names for RDS cluster |
| cloudwatch_log_group_arns_cluster | List of CloudWatch log group ARNs for RDS cluster |

### Connection Information

| Name | Description |
|------|-------------|
| connection_info | Connection information for the database |

## Examples

See the `examples/` directory for complete working examples:

- `examples/basic/` - Basic RDS instance setup
- `examples/aurora/` - Aurora cluster setup
- `examples/advanced/` - Advanced configuration with monitoring and security

## Best Practices

### Security

1. **Encryption**: Always enable storage encryption for production databases
2. **Network Security**: Use private subnets and security groups to restrict access
3. **Password Management**: Use AWS Secrets Manager for password management
4. **IAM Authentication**: Consider using IAM database authentication for Aurora

### Performance

1. **Instance Sizing**: Choose appropriate instance classes based on workload
2. **Storage**: Use GP3 for better performance and cost efficiency
3. **Monitoring**: Enable Performance Insights for production workloads
4. **Backup Strategy**: Implement appropriate backup retention policies

### High Availability

1. **Multi-AZ**: Enable Multi-AZ deployment for production databases
2. **Aurora**: Consider Aurora for better scalability and availability
3. **Read Replicas**: Use read replicas to offload read traffic

### Cost Optimization

1. **Instance Types**: Use appropriate instance types for your workload
2. **Storage**: Monitor storage usage and adjust as needed
3. **Reserved Instances**: Consider reserved instances for predictable workloads
4. **Aurora Serverless**: Use Aurora Serverless for variable workloads

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the Apache 2.0 License. See the LICENSE file for details.

## Support

For issues and questions, please open an issue in the repository or contact the maintainers. 