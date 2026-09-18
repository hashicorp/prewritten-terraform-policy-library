# Copyright IBM Corp. 2026

policytest {
  targets = [
    "ec2-instance-no-public-ip.policy.hcl"
  ]
}

# Test 1: Pass - No associate_public_ip_address attribute set, subnet is private
resource "aws_instance" "pass_no_attribute" {
  attrs = {
    ami           = "ami-12345678"
    instance_type = "t2.micro"
    subnet_id     = "subnet-private"
  }
}

resource "aws_subnet" "private_subnet" {
  attrs = {
    id                      = "subnet-private"
    map_public_ip_on_launch = false
  }
}

# Test 2: Pass - associate_public_ip_address explicitly set to false
resource "aws_instance" "pass_explicit_false" {
  attrs = {
    ami                         = "ami-12345678"
    instance_type               = "t2.micro"
    subnet_id                   = "subnet-12345678"
    associate_public_ip_address = false
  }
}

# Test 3: Fail - associate_public_ip_address set to true
resource "aws_instance" "fail_explicit_true" {
  expect_failure = true
  attrs = {
    ami                         = "ami-12345678"
    instance_type               = "t2.micro"
    subnet_id                   = "subnet-12345678"
    associate_public_ip_address = true
  }
}

# Test 8: FAIL - No associate_public_ip_address set but subnet has map_public_ip_on_launch=true.
resource "aws_instance" "fail_subnet_auto_assigns_public" {
  expect_failure = true
  attrs = {
    ami           = "ami-12345678"
    instance_type = "t2.micro"
    subnet_id     = "subnet-auto-public"
  }
}

resource "aws_subnet" "auto_public_subnet" {
  attrs = {
    id                      = "subnet-auto-public"
    map_public_ip_on_launch = true
  }
}

# Test 9: PASS - No associate_public_ip_address set and subnet has map_public_ip_on_launch=false
resource "aws_instance" "pass_subnet_private" {
  attrs = {
    ami           = "ami-12345678"
    instance_type = "t2.micro"
    subnet_id     = "subnet-explicitly-private"
  }
}

resource "aws_subnet" "explicitly_private_subnet" {
  attrs = {
    id                      = "subnet-explicitly-private"
    map_public_ip_on_launch = false
  }
}