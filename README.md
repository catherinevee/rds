# AWS RDS Terraform Module

Terraform module for creating AWS RDS instances and Aurora clusters with enterprise security, monitoring, and compliance features.

## Features

- RDS instances with MySQL, PostgreSQL, MariaDB, Oracle, and SQL Server engines
- Aurora clusters with read replicas and multi-AZ deployments
- Security groups with least-privilege network access
- Database subnet groups for VPC placement
- KMS encryption for data at rest and in transit
- CloudWatch integration with Performance Insights
- Automated backups with configurable retention
- High availability with Multi-AZ and read replicas

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

## Resource Architecture

### Core Database Resources
- `aws_db_instance` - Single database instance
- `aws_rds_cluster` - Aurora database cluster
- `aws_rds_cluster_instance` - Individual cluster instances

### Security Resources
- `aws_security_group` - Database network security
- `aws_security_group_rule` - Network access rules
- `aws_db_subnet_group` - Database subnet configuration

### Monitoring Resources
- `aws_cloudwatch_log_group` - Database log storage
- `aws_cloudwatch_log_group` - Cluster log storage

### Advanced Features
- `aws_appautoscaling_target` - Aurora cluster auto scaling
- `aws_appautoscaling_policy` - Auto scaling policies
- `aws_db_instance` - Database read replicas
- `aws_rds_global_cluster` - Cross-region Aurora clusters
- `aws_db_parameter_group` - Database parameter configuration
- `aws_rds_cluster_parameter_group` - Cluster parameter configuration
- `aws_db_option_group` - Database option configuration
- `aws_db_event_subscription` - Database event notifications
- `aws_db_proxy` - Database connection pooling
- `aws_db_proxy_default_target_group` - Proxy target configuration
- `aws_db_snapshot` - Database snapshots
- `aws_rds_cluster_snapshot` - Cluster snapshots
- `aws_rds_export_task` - Database export to S3

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_rds_instance | Create RDS instance | `bool` | `false` | no |
| create_rds_cluster | Create RDS cluster | `bool` | `false` | no |
| identifier | Database name | `string` | n/a | yes |
| engine | Database engine | `string` | `"mysql"` | no |
| instance_class | Instance type | `string` | `"db.t3.micro"` | no |
| allocated_storage | Storage in gigabytes | `number` | `20` | no |
| username | Master username | `string` | n/a | yes |
| password | Master password | `string` | n/a | yes |
| vpc_security_group_ids | Security group IDs | `list(string)` | `[]` | no |
| db_subnet_group_name | Subnet group name | `string` | n/a | yes |
| create_security_group | Create security group | `bool` | `false` | no |
| create_db_subnet_group | Create subnet group | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | RDS instance ID |
| db_instance_endpoint | Connection endpoint |
| db_instance_address | Instance address |
| db_instance_port | Database port |
| db_cluster_id | RDS cluster ID |
| db_cluster_endpoint | Cluster endpoint |
| db_cluster_reader_endpoint | Cluster reader endpoint |
| security_group_id | Security group ID |
| db_subnet_group_id | Subnet group ID |

## Examples

### Getting Started
- [Basic Example](./examples/basic) - Minimal RDS instance configuration
- [Development Example](./examples/development) - Cost-optimized for development

### Production Workloads
- [Advanced Example](./examples/advanced) - Full-featured configuration with monitoring
- [Enterprise Example](./examples/enterprise) - Maximum security and compliance
- [Read Replica Example](./examples/read-replica) - Primary with read replicas

### Database Engines
- [MySQL Example](./examples/mysql) - MySQL-specific configurations
- [PostgreSQL Example](./examples/postgresql) - PostgreSQL-specific configurations

### Aurora Clusters
- [Aurora Example](./examples/aurora) - Aurora MySQL cluster
- [Aurora PostgreSQL Example](./examples/aurora-postgresql) - Aurora PostgreSQL cluster

### Infrastructure Management
- [Terragrunt Example](./examples/terragrunt) - Using with Terragrunt

## Contributing

See [Contributing Guide](CONTRIBUTING.md) for contribution guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

For support and questions:
- Create an issue in this repository
- Review the [examples](./examples) directory
- Check the [troubleshooting guide](TROUBLESHOOTING.md)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history. 