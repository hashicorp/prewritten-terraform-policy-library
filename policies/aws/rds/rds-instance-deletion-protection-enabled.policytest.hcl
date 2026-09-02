# Copyright IBM Corp. 2026

policytest {
    targets = [
        "rds-instance-deletion-protection-enabled.policy.hcl"
    ]
}

# Test 1: PASS - MySQL instance with deletion_protection enabled
resource "aws_db_instance" "pass_mysql" {
    attrs = {
        db_name             = "mydb"
        engine              = "mysql"
        instance_class      = "db.t3.micro"
        username            = "foo"
        deletion_protection = true
    }
}

# Test 2: FAIL - MySQL instance with deletion_protection disabled
resource "aws_db_instance" "fail_mysql" {
    expect_failure = true
    attrs = {
        db_name             = "mydb"
        engine              = "mysql"
        instance_class      = "db.t3.micro"
        username            = "foo"
        deletion_protection = false
    }
}

# Test 3: FAIL - MySQL instance with deletion_protection missing (defaults to false)
resource "aws_db_instance" "fail_mysql_missing_protection" {
    expect_failure = true
    attrs = {
        db_name        = "mydb"
        engine         = "mysql"
        instance_class = "db.t3.micro"
        username       = "foo"
    }
}

# Test 4: PASS - PostgreSQL instance with deletion_protection enabled
resource "aws_db_instance" "pass_postgres" {
    attrs = {
        db_name             = "mydb"
        engine              = "postgres"
        instance_class      = "db.t3.micro"
        username            = "foo"
        deletion_protection = true
    }
}

# Test 5: FAIL - PostgreSQL instance with deletion_protection disabled
resource "aws_db_instance" "fail_postgres" {
    expect_failure = true
    attrs = {
        db_name             = "mydb"
        engine              = "postgres"
        instance_class      = "db.t3.micro"
        username            = "foo"
        deletion_protection = false
    }
}

# Test 6: PASS - MariaDB instance with deletion_protection enabled
resource "aws_db_instance" "pass_mariadb" {
    attrs = {
        db_name             = "mydb"
        engine              = "mariadb"
        instance_class      = "db.t3.micro"
        username            = "foo"
        deletion_protection = true
    }
}

# Test 7: PASS - SQL Server EE instance with deletion_protection enabled
resource "aws_db_instance" "pass_sqlserver_ee" {
    attrs = {
        engine              = "sqlserver-ee"
        instance_class      = "db.t3.xlarge"
        username            = "foo"
        deletion_protection = true
    }
}

# Test 8: PASS - Oracle EE instance with deletion_protection enabled
resource "aws_db_instance" "pass_oracle_ee" {
    attrs = {
        engine              = "oracle-ee"
        instance_class      = "db.t3.xlarge"
        username            = "foo"
        deletion_protection = true
    }
}

# Test 9: SKIP - Aurora engine is not in the supported list, filtered out
resource "aws_db_instance" "skip_aurora_engine" {
    skip = true
    attrs = {
        db_name             = "mydb"
        engine              = "aurora"
        instance_class      = "db.t3.micro"
        username            = "foo"
        deletion_protection = false
    }
}

# Test 10: SKIP - Missing engine attribute, not in supported list, filtered out
resource "aws_db_instance" "skip_no_engine" {
    skip = true
    attrs = {
        db_name             = "mydb"
        instance_class      = "db.t3.micro"
        username            = "foo"
        deletion_protection = false
    }
}
