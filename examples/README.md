# RDS Module Examples

Comprehensive examples demonstrating various use cases and configurations for the AWS RDS Terraform module.

## Example Overview

| Example | Description | Use Case |
|---------|-------------|----------|
| [Basic](./basic/) | Minimal RDS instance configuration | Getting started, simple deployments |
| [Advanced](./advanced/) | Full-featured RDS with monitoring and security | Production workloads with enhanced features |
| [Aurora](./aurora/) | Aurora MySQL cluster configuration | High-performance, scalable database clusters |
| [Aurora PostgreSQL](./aurora-postgresql/) | Aurora PostgreSQL cluster configuration | PostgreSQL workloads with Aurora benefits |
| [PostgreSQL](./postgresql/) | PostgreSQL RDS instance configuration | PostgreSQL-specific features and optimizations |
| [MySQL](./mysql/) | MySQL RDS instance configuration | MySQL-specific features and optimizations |
| [Development](./development/) | Development environment configuration | Cost-optimized for development and testing |
| [Enterprise](./enterprise/) | Enterprise-grade configuration | Maximum security, compliance, and monitoring |
| [Read Replica](./read-replica/) | Primary instance with read replicas | Read scaling and disaster recovery |
| [Terragrunt](./terragrunt/) | Terragrunt integration example | Using the module with Terragrunt |

## Quick Start

### Prerequisites

1. Terraform: Version 1.13.0 or later
2. AWS Provider: Version 6.2.0
3. AWS CLI: Configured with appropriate permissions
4. VPC and Subnets: Available for database placement

### Basic Usage

```bash
# Navigate to an example directory
cd examples/basic

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## Example Details

### Basic Example
**Location**: `./basic/`
**Purpose**: Minimal RDS instance for getting started
**Features**:
- Single RDS instance
- Basic security group
- Standard backup configuration
- Minimal monitoring

**Use Case**: Learning, testing, simple applications

### Advanced Example
**Location**: `./advanced/`
**Purpose**: Production-ready RDS with enhanced features
**Features**:
- Enhanced monitoring with IAM roles
- Performance Insights
- CloudWatch logging
- Custom security group rules
- Multi-AZ deployment

**Use Case**: Production applications requiring high availability and monitoring

### Aurora Examples
**Location**: `./aurora/` and `./aurora-postgresql/`
**Purpose**: Aurora cluster deployments
**Features**:
- Multi-instance Aurora clusters
- Read replicas
- Cluster-specific configurations
- Aurora-specific optimizations

**Use Case**: High-performance, scalable database workloads

### Engine-Specific Examples
**Location**: `./postgresql/` and `./mysql/`
**Purpose**: Engine-specific optimizations and features
**Features**:
- Engine-specific parameter groups
- Optimized configurations for each engine
- Engine-specific CloudWatch logs
- Character set configurations

**Use Case**: Applications requiring specific database engine features

### Development Example
**Location**: `./development/`
**Purpose**: Cost-optimized for development environments
**Features**:
- Minimal resource allocation
- Disabled expensive features
- Relaxed security for development
- Cost optimization tags

**Use Case**: Development, testing, and staging environments

### Enterprise Example
**Location**: `./enterprise/`
**Purpose**: Maximum security and compliance
**Features**:
- KMS encryption
- Enhanced monitoring
- CloudWatch alarms
- Strict security groups
- Compliance tagging
- Maximum backup retention

**Use Case**: Enterprise applications requiring maximum security and compliance

### Read Replica Example
**Location**: `./read-replica/`
**Purpose**: Read scaling and disaster recovery
**Features**:
- Primary instance with multiple read replicas
- Replica-specific configurations
- Load distribution setup
- Disaster recovery preparation

**Use Case**: Applications requiring read scaling or disaster recovery

### Terragrunt Example
**Location**: `./terragrunt/`
**Purpose**: Terragrunt integration
**Features**:
- Terragrunt configuration
- Dependency management
- Environment-specific variables
- Mock outputs for planning

**Use Case**: Organizations using Terragrunt for infrastructure management

## Configuration Options

### Common Variables

All examples use these common configuration patterns:

```hcl
# Basic configuration
create_rds_instance = true
identifier         = "example-database"
engine             = "mysql"
instance_class     = "db.t3.micro"

# Storage
allocated_storage = 20
storage_type     = "gp2"
storage_encrypted = true

# Authentication
username = "admin"
password = "your-secure-password"

# Security
create_security_group = true
create_db_subnet_group = true

# Backup and maintenance
backup_retention_period = 7
backup_window          = "02:00-03:00"
maintenance_window     = "sun:03:00-sun:04:00"
```

### Environment-Specific Configurations

#### Development Environment
```hcl
# Cost optimization
instance_class = "db.t3.micro"
storage_encrypted = false
multi_az = false
monitoring_interval = 0
performance_insights_enabled = false
deletion_protection = false
```

#### Production Environment
```hcl
# High availability and security
instance_class = "db.t3.medium"
storage_encrypted = true
multi_az = true
monitoring_interval = 60
performance_insights_enabled = true
deletion_protection = true
```

#### Enterprise Environment
```hcl
# Maximum security and compliance
instance_class = "db.r6g.xlarge"
storage_encrypted = true
kms_key_id = aws_kms_key.rds_encryption.arn
monitoring_interval = 60
monitoring_role_arn = aws_iam_role.rds_monitoring.arn
performance_insights_enabled = true
performance_insights_retention_period = 31
```

## Security Considerations

### Network Security
- All examples create security groups with appropriate rules
- Database access is restricted to VPC CIDR ranges
- Public access is disabled by default

### Encryption
- Storage encryption is enabled by default
- Enterprise example includes KMS key management
- Development example disables encryption for cost savings

### Authentication
- Strong password requirements
- IAM database authentication can be enabled
- Secrets management integration possible

## Monitoring and Logging

### CloudWatch Integration
- Enhanced monitoring with custom IAM roles
- Performance Insights for query analysis
- CloudWatch logs for database logs
- Custom CloudWatch alarms

### Log Types by Engine
- MySQL: `error`, `general`, `slow_query`
- PostgreSQL: `postgresql`, `error`, `general`
- Aurora: Additional `audit` logs

## Cost Optimization

### Development Environments
- Use smaller instance classes (`db.t3.micro`)
- Disable expensive features
- Minimal backup retention
- Single-AZ deployment

### Production Environments
- Right-size instance classes
- Enable Multi-AZ for high availability
- Appropriate backup retention
- Performance Insights for optimization

## Best Practices

### Naming Conventions
- Use descriptive identifiers
- Include environment in names
- Consistent tagging strategy

### Resource Organization
- Separate security groups and subnet groups
- Use consistent naming patterns
- Proper tagging for cost allocation

### Security
- Enable encryption at rest
- Use VPC security groups
- Implement least privilege access
- Regular security updates

### Monitoring
- Enable enhanced monitoring
- Set up CloudWatch alarms
- Use Performance Insights
- Monitor backup and maintenance windows

## Troubleshooting

### Common Issues

1. VPC Configuration
   - Ensure subnets are in the correct VPC
   - Verify subnet group configuration
   - Check security group rules

2. Authentication
   - Verify username and password
   - Check IAM permissions
   - Ensure database name is valid

3. Storage
   - Verify storage type compatibility
   - Check IOPS requirements
   - Ensure sufficient storage allocation

4. Monitoring
   - Verify IAM role permissions
   - Check CloudWatch log configuration
   - Ensure Performance Insights is enabled

### Getting Help

- Review the [main module documentation](../README.md)
- Check the [comprehensive analysis](../COMPREHENSIVE_ANALYSIS.md)
- Create an issue in the repository
- Review AWS RDS documentation

## Contributing

When adding new examples:

1. Follow the existing naming conventions
2. Include comprehensive comments
3. Add appropriate outputs
4. Update this README
5. Test the example thoroughly
6. Include cost considerations
7. Document security implications

## License

These examples are provided under the same license as the main module. See the [LICENSE](../LICENSE) file for details. 