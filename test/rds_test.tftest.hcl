# RDS Module Tests
# Comprehensive test suite for AWS RDS Terraform module

# Test basic RDS instance creation
run "test_basic_rds_instance" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-instance"
    engine             = "mysql"
    engine_version     = "8.0.35"
    instance_class     = "db.t3.micro"
    allocated_storage  = 20
    storage_type       = "gp2"
    storage_encrypted  = true
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    backup_retention_period = 7
    deletion_protection = false
    skip_final_snapshot = true
  }
  
  assert {
    condition     = aws_db_instance.rds[0].engine == "mysql"
    error_message = "Engine should be mysql"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].instance_class == "db.t3.micro"
    error_message = "Instance class should be db.t3.micro"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].allocated_storage == 20
    error_message = "Allocated storage should be 20 GB"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].storage_encrypted == true
    error_message = "Storage should be encrypted"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].backup_retention_period == 7
    error_message = "Backup retention period should be 7 days"
  }
  
  assert {
    condition     = aws_security_group.rds[0].name == "test-instance-sg"
    error_message = "Security group should have correct name"
  }
  
  assert {
    condition     = aws_db_subnet_group.rds[0].name == "test-instance-subnet-group"
    error_message = "DB subnet group should have correct name"
  }
}

# Test Aurora cluster creation
run "test_aurora_cluster" {
  command = plan
  
  variables {
    create_rds_cluster = true
    identifier         = "test-cluster"
    engine             = "aurora-mysql"
    engine_version     = "8.0.mysql_aurora.3.04.1"
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
    cluster_master_username = "admin"
    cluster_master_password = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    cluster_backup_retention_period = 7
    cluster_deletion_protection = false
    cluster_skip_final_snapshot = true
  }
  
  assert {
    condition     = aws_rds_cluster.rds[0].engine == "aurora-mysql"
    error_message = "Cluster engine should be aurora-mysql"
  }
  
  assert {
    condition     = aws_rds_cluster.rds[0].backup_retention_period == 7
    error_message = "Cluster backup retention period should be 7 days"
  }
  
  assert {
    condition     = length(aws_rds_cluster_instance.rds) == 2
    error_message = "Should create 2 cluster instances"
  }
  
  assert {
    condition     = aws_rds_cluster_instance.rds["primary"].instance_class == "db.r6g.large"
    error_message = "Primary instance should be db.r6g.large"
  }
  
  assert {
    condition     = aws_rds_cluster_instance.rds["replica1"].instance_class == "db.r6g.large"
    error_message = "Replica instance should be db.r6g.large"
  }
}

# Test PostgreSQL RDS instance
run "test_postgresql_instance" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-postgres"
    engine             = "postgres"
    engine_version     = "15.4"
    instance_class     = "db.t3.micro"
    allocated_storage  = 20
    storage_type       = "gp3"
    storage_encrypted  = true
    username           = "postgres"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    backup_retention_period = 7
    deletion_protection = false
    skip_final_snapshot = true
    performance_insights_enabled = true
    monitoring_interval = 60
  }
  
  assert {
    condition     = aws_db_instance.rds[0].engine == "postgres"
    error_message = "Engine should be postgres"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].storage_type == "gp3"
    error_message = "Storage type should be gp3"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].performance_insights_enabled == true
    error_message = "Performance Insights should be enabled"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].monitoring_interval == 60
    error_message = "Monitoring interval should be 60 seconds"
  }
}

# Test security group rules
run "test_security_group_rules" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-sg-rules"
    engine             = "mysql"
    instance_class     = "db.t3.micro"
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
    security_group_rules = [
      {
        type        = "ingress"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/8"]
        description = "MySQL access from VPC"
      },
      {
        type        = "egress"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
      }
    ]
  }
  
  assert {
    condition     = length(aws_security_group_rule.rds) == 2
    error_message = "Should create 2 security group rules"
  }
  
  assert {
    condition     = aws_security_group_rule.rds["ingress-3306-3306-tcp"].type == "ingress"
    error_message = "First rule should be ingress"
  }
  
  assert {
    condition     = aws_security_group_rule.rds["egress-0-0--1"].type == "egress"
    error_message = "Second rule should be egress"
  }
}

# Test variable validation - invalid instance class
run "test_invalid_instance_class" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-invalid"
    engine             = "mysql"
    instance_class     = "invalid-instance-class"
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
  }
  
  expect_failures = [
    aws_db_instance.rds,
  ]
}

# Test variable validation - invalid engine
run "test_invalid_engine" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-invalid-engine"
    engine             = "invalid-engine"
    instance_class     = "db.t3.micro"
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
  }
  
  expect_failures = [
    aws_db_instance.rds,
  ]
}

# Test variable validation - invalid storage size
run "test_invalid_storage" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-invalid-storage"
    engine             = "mysql"
    instance_class     = "db.t3.micro"
    allocated_storage  = 10  # Below minimum of 20
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
  }
  
  expect_failures = [
    aws_db_instance.rds,
  ]
}

# Test CloudWatch logs integration
run "test_cloudwatch_logs" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-cloudwatch"
    engine             = "mysql"
    instance_class     = "db.t3.micro"
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
    enable_cloudwatch_logs_exports = ["error", "general", "slow_query"]
  }
  
  assert {
    condition     = length(aws_cloudwatch_log_group.rds_instance) == 3
    error_message = "Should create 3 CloudWatch log groups"
  }
  
  assert {
    condition     = aws_cloudwatch_log_group.rds_instance["error"].name == "/aws/rds/instance/test-cloudwatch/error"
    error_message = "Error log group should have correct name"
  }
  
  assert {
    condition     = aws_cloudwatch_log_group.rds_instance["general"].name == "/aws/rds/instance/test-cloudwatch/general"
    error_message = "General log group should have correct name"
  }
  
  assert {
    condition     = aws_cloudwatch_log_group.rds_instance["slow_query"].name == "/aws/rds/instance/test-cloudwatch/slow_query"
    error_message = "Slow query log group should have correct name"
  }
}

# Test Aurora cluster with CloudWatch logs
run "test_aurora_cloudwatch_logs" {
  command = plan
  
  variables {
    create_rds_cluster = true
    identifier         = "test-aurora-cloudwatch"
    engine             = "aurora-mysql"
    cluster_instances = {
      primary = {
        identifier     = "primary"
        instance_class = "db.r6g.large"
      }
    }
    cluster_master_username = "admin"
    cluster_master_password = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    cluster_skip_final_snapshot = true
    cluster_enable_cloudwatch_logs_exports = ["error", "general", "slow_query", "audit"]
  }
  
  assert {
    condition     = length(aws_cloudwatch_log_group.rds_cluster) == 4
    error_message = "Should create 4 CloudWatch log groups for cluster"
  }
  
  assert {
    condition     = aws_cloudwatch_log_group.rds_cluster["error"].name == "/aws/rds/cluster/test-aurora-cloudwatch/error"
    error_message = "Cluster error log group should have correct name"
  }
}

# Test tags and naming
run "test_tags_and_naming" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-tags"
    engine             = "mysql"
    instance_class     = "db.t3.micro"
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
    tags = {
      Environment = "test"
      Project     = "terraform-testing"
      Owner       = "devops-team"
      CostCenter  = "database"
    }
  }
  
  assert {
    condition     = aws_db_instance.rds[0].tags["Environment"] == "test"
    error_message = "RDS instance should have Environment tag"
  }
  
  assert {
    condition     = aws_db_instance.rds[0].tags["Project"] == "terraform-testing"
    error_message = "RDS instance should have Project tag"
  }
  
  assert {
    condition     = aws_security_group.rds[0].tags["Environment"] == "test"
    error_message = "Security group should have Environment tag"
  }
  
  assert {
    condition     = aws_db_subnet_group.rds[0].tags["Environment"] == "test"
    error_message = "DB subnet group should have Environment tag"
  }
}

# Test multi-AZ configuration
run "test_multi_az" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-multi-az"
    engine             = "mysql"
    instance_class     = "db.t3.micro"
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
    multi_az = true
  }
  
  assert {
    condition     = aws_db_instance.rds[0].multi_az == true
    error_message = "Multi-AZ should be enabled"
  }
}

# Test deletion protection
run "test_deletion_protection" {
  command = plan
  
  variables {
    create_rds_instance = true
    identifier         = "test-deletion-protection"
    engine             = "mysql"
    instance_class     = "db.t3.micro"
    username           = "admin"
    password           = "test-password-123!"
    create_security_group = true
    create_db_subnet_group = true
    skip_final_snapshot = true
    deletion_protection = true
  }
  
  assert {
    condition     = aws_db_instance.rds[0].deletion_protection == true
    error_message = "Deletion protection should be enabled"
  }
} 