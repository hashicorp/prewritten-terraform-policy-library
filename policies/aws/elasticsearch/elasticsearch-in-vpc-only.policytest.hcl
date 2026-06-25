# Copyright IBM Corp. 2026

policytest {
  targets = ["elasticsearch-in-vpc-only.policy.hcl"]
}

# PASS: Domain with vpc_options block and one subnet ID
resource "aws_elasticsearch_domain" "pass_with_vpc_single_subnet" {
  attrs = {
    domain_name           = "vpc-domain-single-subnet"
    elasticsearch_version = "7.10"
    vpc_options = [{
      subnet_ids         = ["subnet-12345678"]
      security_group_ids = ["sg-12345678"]
    }]
  }
}

# PASS: Domain with vpc_options block and multiple subnet IDs
resource "aws_elasticsearch_domain" "pass_with_vpc_multiple_subnets" {
  attrs = {
    domain_name           = "vpc-domain-multi-subnet"
    elasticsearch_version = "7.10"
    vpc_options = [{
      subnet_ids         = ["subnet-11111111", "subnet-22222222"]
      security_group_ids = ["sg-12345678"]
    }]
  }
}

# FAIL: Domain without vpc_options block
resource "aws_elasticsearch_domain" "fail_no_vpc_options" {
  expect_failure = true
  attrs = {
    domain_name           = "public-domain-no-vpc"
    elasticsearch_version = "7.10"
  }
}

# FAIL: Domain with vpc_options block but empty subnet_ids list
resource "aws_elasticsearch_domain" "fail_empty_subnet_ids" {
  expect_failure = true
  attrs = {
    domain_name           = "vpc-domain-empty-subnets"
    elasticsearch_version = "7.10"
    vpc_options = [{
      subnet_ids         = []
      security_group_ids = ["sg-12345678"]
    }]
  }
}

# FAIL: Domain with vpc_options set to null
resource "aws_elasticsearch_domain" "fail_vpc_options_null" {
  expect_failure = true
  attrs = {
    domain_name           = "domain-vpc-null"
    elasticsearch_version = "7.10"
    vpc_options           = null
  }
}

# FAIL: Domain where vpc_options attribute is entirely omitted
resource "aws_elasticsearch_domain" "fail_vpc_options_omitted" {
  expect_failure = true
  attrs = {
    domain_name = "domain-vpc-omitted"
  }
}
