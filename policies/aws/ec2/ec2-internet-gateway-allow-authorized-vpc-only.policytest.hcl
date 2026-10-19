# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-internet-gateway-allow-authorized-vpc-only.policy.hcl"]
}

# PASS: igw no vpc id
resource "aws_internet_gateway" "pass_igw_no_vpc_id" {
  attrs = {
    tags = {
      Name = "igw-no-vpc-id"
    }
  }
}

# FAIL: igw no authorized list
resource "aws_internet_gateway" "fail_igw_no_authorized_list" {
  expect_failure = true
  attrs = {
    vpc_id = "vpc-0123456789abcdef0"
    tags = {
      Name = "igw-unauthorized-no-list"
    }
  }
}

# FAIL: attachment no authorized list
resource "aws_internet_gateway_attachment" "fail_attachment_no_authorized_list" {
  expect_failure = true
  attrs = {
    internet_gateway_id = "igw-0123456789abcdef0"
    vpc_id              = "vpc-0123456789abcdef0"
  }
}

# FAIL: igw unauthorized vpc
resource "aws_internet_gateway" "fail_igw_unauthorized_vpc_f2" {
  expect_failure = true
  attrs = {
    vpc_id = "vpc-0999999unauthorized"
    tags = {
      Name = "igw-unauthorized"
    }
  }
}

# FAIL: igw empty vpc id
resource "aws_internet_gateway" "fail_igw_empty_vpc_id_f2" {
  expect_failure = true
  attrs = {
    vpc_id = ""
    tags = {
      Name = "igw-empty-vpc-id"
    }
  }
}

# FAIL: aws_internet_gateway_attachment with vpc_id NOT in the authorized list
resource "aws_internet_gateway_attachment" "fail_attachment_unauthorized_vpc_f2" {
  expect_failure = true
  attrs = {
    internet_gateway_id = "igw-0abc123456789abcd"
    vpc_id              = "vpc-0999999unauthorized"
  }
}
