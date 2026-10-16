# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-belong-to-vpc.policy.hcl"]
}

# PASS: subnet_id alone is sufficient when no specific VPC is required
resource "aws_instance" "pass_subnet_id" {
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = "subnet-0123456789abcdef0"
  }
}

# FAIL: subnet_id is an empty string (treated as not configured) and nothing else is set
resource "aws_instance" "fail_empty_subnet_id_only" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = ""
  }
}

# PASS: vpc_security_group_ids is a VPC-only attribute
resource "aws_instance" "pass_vpc_sg" {
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    vpc_security_group_ids = ["sg-0123456789abcdef0"]
  }
}

# FAIL: vpc_security_group_ids is an empty list and nothing else is set
resource "aws_instance" "fail_empty_vpc_sg_only" {
  expect_failure = true
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    vpc_security_group_ids = []
  }
}

resource "aws_network_interface" "ni_with_subnet" {
  skip = true
  attrs = {
    id        = "eni-aaaa1111"
    subnet_id = "subnet-0123456789abcdef0"
  }
}

resource "aws_network_interface" "ni_without_subnet" {
  skip = true
  attrs = {
    id        = "eni-bbbb2222"
    subnet_id = null
  }
}

# PASS: primary_network_interface references an ENI that has subnet_id configured
resource "aws_instance" "pass_primary_ni_valid" {
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    primary_network_interface = [
      {
        network_interface_id = aws_network_interface.ni_with_subnet.id
      }
    ]
  }
}

# FAIL: primary_network_interface references an ENI that does NOT have subnet_id configured
resource "aws_instance" "fail_primary_ni_no_subnet" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    primary_network_interface = [
      {
        network_interface_id = aws_network_interface.ni_without_subnet.id
      }
    ]
  }
}

# FAIL: primary ni unresolvable
resource "aws_instance" "fail_primary_ni_unresolvable" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    primary_network_interface = [
      {
        network_interface_id = "eni-does-not-exist-9999"
      }
    ]
  }
}

# FAIL: none of subnet_id, vpc_security_group_ids, or primary_network_interface are set
resource "aws_instance" "fail_no_vpc_attrs" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
  }
}

# FAIL: only the deprecated network_interface block is set
resource "aws_instance" "fail_deprecated_network_interface_only" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    network_interface = [
      {
        device_index          = 0
        network_interface_id  = "eni-cccc3333"
        delete_on_termination = null
        network_card_index    = null
      }
    ]
  }
}

# PASS: subnet_id is checked first and takes priority over vpc_security_group_ids
resource "aws_instance" "pass_subnet_priority_over_vpc_sg" {
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    subnet_id              = "subnet-0123456789abcdef0"
    vpc_security_group_ids = ["sg-0123456789abcdef0"]
  }
}

resource "aws_subnet" "matching_vpc_f2" {
  skip = true
  attrs = {
    id         = "subnet-aaaa0001"
    vpc_id     = "vpc-aaaa1111"
    cidr_block = "10.0.1.0/24"
  }
}

resource "aws_subnet" "mismatched_vpc_f2" {
  skip = true
  attrs = {
    id         = "subnet-bbbb0002"
    vpc_id     = "vpc-bbbb2222"
    cidr_block = "10.0.2.0/24"
  }
}

# PASS: subnet_id references a subnet that belongs to the required vpc_id
resource "aws_instance" "pass_subnet_matching_vpc_f2" {
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = aws_subnet.matching_vpc_f2.id
  }
}

# PASS: subnet_id does not match any aws_subnet resource in this plan (e.g
resource "aws_instance" "pass_subnet_unresolvable_with_vpc_required_f2" {
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = "subnet-does-not-exist-9999"
  }
}
