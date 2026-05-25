policytest {
  targets = [
    "dms-mongo-db-authentication-enabled.policy.hcl"
  ]
}

# Pass Case 1: MongoDB endpoint with default authentication
resource "aws_dms_endpoint" "pass_with_default_auth" {
  attrs = {
    endpoint_id   = "mongodb-endpoint-1"
    endpoint_type = "source"
    engine_name   = "mongodb"
    mongodb_settings = [
      {
        auth_type      = "password"
        auth_mechanism = "default"
        auth_source    = "admin"
      }
    ]
    username      = "mongouser"
    password      = "mongopass"
    server_name   = "mongodb.example.com"
    port          = 27017
    database_name = "mydb"
  }
}

# Pass Case 2: MongoDB endpoint with SCRAM-SHA-1 authentication
resource "aws_dms_endpoint" "pass_with_scram_sha1" {
  attrs = {
    endpoint_id   = "mongodb-endpoint-2"
    endpoint_type = "source"
    engine_name   = "mongodb"
    mongodb_settings = [
      {
        auth_type      = "password"
        auth_mechanism = "scram_sha_1"
        auth_source    = "admin"
      }
    ]
    username      = "mongouser"
    password      = "mongopass"
    server_name   = "mongodb.example.com"
    port          = 27017
    database_name = "mydb"
  }
}

# Pass Case 3: MongoDB endpoint with MONGODB-CR authentication
resource "aws_dms_endpoint" "pass_with_mongodb_cr" {
  attrs = {
    endpoint_id   = "mongodb-endpoint-3"
    endpoint_type = "target"
    engine_name   = "mongodb"
    mongodb_settings = [
      {
        auth_type      = "password"
        auth_mechanism = "mongodb_cr"
        auth_source    = "admin"
      }
    ]
    username      = "mongouser"
    password      = "mongopass"
    server_name   = "mongodb.example.com"
    port          = 27017
    database_name = "mydb"
  }
}

# Fail Case 1: MongoDB endpoint without mongodb_settings block
resource "aws_dms_endpoint" "fail_missing_mongodb_settings" {
  expect_failure = true
  attrs = {
    endpoint_id   = "mongodb-endpoint-4"
    endpoint_type = "source"
    engine_name   = "mongodb"
    server_name   = "mongodb.example.com"
    port          = 27017
    database_name = "mydb"
  }
}

# Fail Case 2: MongoDB endpoint with auth_type set to "no"
resource "aws_dms_endpoint" "fail_auth_type_no" {
  expect_failure = true
  attrs = {
    endpoint_id   = "mongodb-endpoint-5"
    endpoint_type = "source"
    engine_name   = "mongodb"
    mongodb_settings = [
      {
        auth_type      = "no"
        auth_mechanism = "default"
      }
    ]
    server_name   = "mongodb.example.com"
    port          = 27017
    database_name = "mydb"
  }
}

# Fail Case 3: MongoDB endpoint without auth_mechanism
resource "aws_dms_endpoint" "fail_missing_auth_mechanism" {
  expect_failure = true
  attrs = {
    endpoint_id   = "mongodb-endpoint-6"
    endpoint_type = "source"
    engine_name   = "mongodb"
    mongodb_settings = [
      {
        auth_type   = "password"
        auth_source = "admin"
      }
    ]
    username      = "mongouser"
    password      = "mongopass"
    server_name   = "mongodb.example.com"
    port          = 27017
    database_name = "mydb"
  }
}

# Fail Case 4: MongoDB endpoint with empty mongodb_settings
resource "aws_dms_endpoint" "fail_empty_mongodb_settings" {
  expect_failure = true
  attrs = {
    endpoint_id   = "mongodb-endpoint-7"
    endpoint_type = "source"
    engine_name   = "mongodb"
    mongodb_settings = [
      {}
    ]
    server_name   = "mongodb.example.com"
    port          = 27017
    database_name = "mydb"
  }
}

# Filter Test: Non-MongoDB endpoint should not be evaluated (passes by default)
resource "aws_dms_endpoint" "filter_non_mongodb_endpoint" {
  attrs = {
    endpoint_id   = "postgres-endpoint-1"
    endpoint_type = "source"
    engine_name   = "postgres"
    server_name   = "postgres.example.com"
    port          = 5432
    database_name = "mydb"
    username      = "pguser"
    password      = "pgpass"
  }
}