# AWS RDS Terraform Module

A comprehensive Terraform module for creating and managing AWS RDS instances and Aurora clusters with enhanced security, monitoring, and compliance features.

## Features

This module provides the following RDS capabilities:

- **RDS Instances**: Single database instances with various engines (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server)
- **Aurora Clusters**: Multi-AZ database clusters with read replicas
- **Security Groups**: Configurable network security with least privilege access
- **Subnet Groups**: Database subnet group management
- **Encryption**: KMS encryption for data at rest and in transit
- **Monitoring**: CloudWatch integration with Performance Insights
- **Backup & Recovery**: Automated backups with configurable retention
- **High Availability**: Multi-AZ deployments and read replicas

## Prerequisites

- Terraform >= 1.0
- AWS Provider >= 5.0
- AWS CLI configured with appropriate permissions
- VPC and subnets for database placement

## Usage

### Basic RDS Instance

```hcl
module "rds" {
  source = "./rds"

  create_rds_instance = true
  identifier         = "my-database"
  
  engine             = "mysql"
  engine_version     = "8.0.35"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  
  username = "admin"
  password = "your-secure-password"
  
  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name   = "my-subnet-group"
  
  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### Aurora Cluster

```hcl
module "aurora" {
  source = "./rds"

  create_rds_cluster = true
  identifier         = "my-aurora-cluster"
  
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.04.1"
  
  cluster_master_username = "admin"
  cluster_master_password = "your-secure-password"
  
  cluster_instances = {
    primary = {
      identifier     = "primary"
      instance_class = "db.r6g.large"
    }
    replica1 = {
      identifier     = "replica-1"
      instance_class = "db.r6g.large"
    }
  }
  
  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name   = "my-subnet-group"
  
  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

## Resource Map

This module creates the following AWS resources based on your configuration:

### Core Database Resources

| Resource Type | AWS Resource | Purpose | Conditional |
|---------------|--------------|---------|-------------|
| **RDS Instance** | | | |
| `aws_db_instance` | RDS Instance | Single database instance | `create_rds_instance = true` |
| **Aurora Cluster** | | | |
| `aws_rds_cluster` | RDS Cluster | Aurora database cluster | `create_rds_cluster = true` |
| `aws_rds_cluster_instance` | RDS Cluster Instance | Individual cluster instances | `create_rds_cluster = true` |

### Security Resources

| Resource Type | AWS Resource | Purpose | Conditional |
|---------------|--------------|---------|-------------|
| **Security Groups** | | | |
| `aws_security_group` | Security Group | Database network security | `create_security_group = true` |
| `aws_security_group_rule` | Security Group Rules | Network access rules | `create_security_group = true` |
| **Subnet Groups** | | | |
| `aws_db_subnet_group` | DB Subnet Group | Database subnet configuration | `create_db_subnet_group = true` |

### Monitoring Resources

| Resource Type | AWS Resource | Purpose | Conditional |
|---------------|--------------|---------|-------------|
| **CloudWatch** | | | |
| `aws_cloudwatch_log_group` | CloudWatch Log Group | Database log storage | `enable_cloudwatch_logs_exports` configured |
| `aws_cloudwatch_log_group` | CloudWatch Log Group | Cluster log storage | `cluster_enable_cloudwatch_logs_exports` configured |

### Advanced Features

| Resource Type | AWS Resource | Purpose | Conditional |
|---------------|--------------|---------|-------------|
| **Auto Scaling** | | | |
| `aws_appautoscaling_target` | Application Auto Scaling Target | Aurora cluster auto scaling | `enable_auto_scaling = true` |
| `aws_appautoscaling_policy` | Application Auto Scaling Policy | Auto scaling policies | `enable_auto_scaling = true` |
| **Read Replicas** | | | |
| `aws_db_instance` | RDS Read Replica | Database read replicas | `enable_read_replica = true` |
| **Global Clusters** | | | |
| `aws_rds_global_cluster` | RDS Global Cluster | Cross-region Aurora clusters | `enable_global_cluster = true` |
| **Parameter Groups** | | | |
| `aws_db_parameter_group` | DB Parameter Group | Database parameter configuration | `enable_cluster_parameter_group = true` |
| `aws_rds_cluster_parameter_group` | RDS Cluster Parameter Group | Cluster parameter configuration | `enable_cluster_parameter_group = true` |
| **Option Groups** | | | |
| `aws_db_option_group` | DB Option Group | Database option configuration | `enable_cluster_option_group = true` |
| **Event Subscriptions** | | | |
| `aws_db_event_subscription` | RDS Event Subscription | Database event notifications | `enable_event_subscription = true` |
| **Proxies** | | | |
| `aws_db_proxy` | RDS Proxy | Database connection pooling | `enable_proxy = true` |
| `aws_db_proxy_default_target_group` | RDS Proxy Target Group | Proxy target configuration | `enable_proxy = true` |
| **Snapshots** | | | |
| `aws_db_snapshot` | RDS Snapshot | Database snapshots | `enable_cluster_snapshot = true` |
| `aws_rds_cluster_snapshot` | RDS Cluster Snapshot | Cluster snapshots | `enable_cluster_snapshot = true` |
| **Export Tasks** | | | |
| `aws_rds_export_task` | RDS Export Task | Database export to S3 | `enable_export_task = true` |

### Resource Dependencies

```
RDS Instance
├── Security Group (if created)
├── DB Subnet Group (if created)
├── CloudWatch Log Groups (if enabled)
├── KMS Key (if encryption enabled)
├── Parameter Group (if custom parameters)
├── Option Group (if custom options)
├── Read Replica (if enabled)
└── Event Subscription (if enabled)

Aurora Cluster
├── Security Group (if created)
├── DB Subnet Group (if created)
├── CloudWatch Log Groups (if enabled)
├── KMS Key (if encryption enabled)
├── Cluster Parameter Group (if custom parameters)
├── Cluster Option Group (if custom options)
├── Auto Scaling (if enabled)
├── Global Cluster (if enabled)
├── Event Subscription (if enabled)
├── Proxy (if enabled)
├── Snapshots (if enabled)
├── Export Tasks (if enabled)
└── Cluster Instances
    ├── Security Group
    ├── CloudWatch Log Groups
    └── Performance Insights
```

### Resource Naming Convention

All resources follow a consistent naming pattern:
- **Identifier**: Uses `identifier` variable as the base name
- **Resource Type**: Descriptive suffix indicating resource type
- **Instance/Cluster**: Additional identifiers for multi-instance deployments

Examples:
- `my-database` (RDS Instance)
- `my-database-sg` (Security Group)
- `my-database-subnet-group` (DB Subnet Group)
- `my-aurora-cluster` (RDS Cluster)
- `my-aurora-cluster-primary` (Cluster Instance)
- `my-database-replica` (Read Replica)
- `my-database-proxy` (RDS Proxy)
- `my-database-snapshot` (Database Snapshot)

### Cost Considerations

**High-Cost Resources:**
- **RDS Instances**: Compute and storage costs based on instance class and storage
- **Aurora Clusters**: Compute costs for cluster and instances, storage costs
- **Provisioned IOPS**: Additional costs for io1 storage type
- **Multi-AZ**: Double compute costs for high availability
- **Read Replicas**: Additional compute costs per replica
- **RDS Proxy**: Additional costs for connection pooling
- **Global Clusters**: Cross-region data transfer costs
- **Performance Insights**: Additional monitoring costs

**Cost Optimization Tips:**
- Use appropriate instance classes for your workload
- Enable auto-scaling for Aurora clusters
- Configure appropriate backup retention periods
- Use gp2/gp3 storage for most workloads
- Monitor Performance Insights usage
- Use RDS Proxy for connection pooling efficiency
- Implement proper tagging for cost allocation

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_rds_instance"></a> [create\_rds\_instance](#input\_create\_rds\_instance) | Whether to create an RDS instance | `bool` | `false` | no |
| <a name="input_create_rds_cluster"></a> [create\_rds\_cluster](#input\_create\_rds\_cluster) | Whether to create an RDS cluster (Aurora) | `bool` | `false` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name of the RDS instance/cluster | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"mysql"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | `"db.t3.micro"` | no |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes | `number` | `20` | no |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate | `list(string)` | `[]` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of DB subnet group | `string` | n/a | yes |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create a security group | `bool` | `false` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Whether to create a DB subnet group | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | The RDS instance ID |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output_db_instance_address"></a> [db\_instance\_address](#output\_db\_instance\_address) | The address of the RDS instance |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | The database port |
| <a name="output_db_cluster_id"></a> [db\_cluster\_id](#output\_db\_cluster\_id) | The RDS cluster ID |
| <a name="output_db_cluster_endpoint"></a> [db\_cluster\_endpoint](#output\_db\_cluster\_endpoint) | The cluster endpoint |
| <a name="output_db_cluster_reader_endpoint"></a> [db\_cluster\_reader\_endpoint](#output\_db\_cluster\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group created for RDS |
| <a name="output_db_subnet_group_id"></a> [db\_subnet\_group\_id](#output\_db\_subnet\_group\_id) | The ID of the DB subnet group |

## Examples

See the [examples](./examples) directory for complete working examples:

### Getting Started
- [Basic Example](./examples/basic) - Minimal RDS instance configuration
- [Development Example](./examples/development) - Cost-optimized for development environments

### Production Workloads
- [Advanced Example](./examples/advanced) - Full-featured configuration with monitoring and security
- [Enterprise Example](./examples/enterprise) - Maximum security, compliance, and monitoring
- [Read Replica Example](./examples/read-replica) - Primary instance with read replicas for scaling

### Database Engines
- [MySQL Example](./examples/mysql) - MySQL-specific configurations and features
- [PostgreSQL Example](./examples/postgresql) - PostgreSQL-specific configurations and features

### Aurora Clusters
- [Aurora Example](./examples/aurora) - Aurora MySQL cluster with read replicas
- [Aurora PostgreSQL Example](./examples/aurora-postgresql) - Aurora PostgreSQL cluster configuration

### Infrastructure Management
- [Terragrunt Example](./examples/terragrunt) - Using the module with Terragrunt

For detailed information about each example, see the [Examples README](./examples/README.md).

## Contributing

Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an issue in this repository
- Review the [examples](./examples) directory
- Check the [troubleshooting guide](TROUBLESHOOTING.md)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes and improvements. 