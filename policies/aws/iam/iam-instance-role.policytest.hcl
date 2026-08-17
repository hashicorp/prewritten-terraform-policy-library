policytest {
  targets = ["iam-instance-role.policy.hcl"]
}

# PASS: A non-empty IAM instance profile satisfies the requirement.
resource "aws_instance" "with_iam_instance_profile" {
  attrs = {
    ami                  = "ami-12345678"
    instance_type        = "t3.micro"
    iam_instance_profile = "application-instance-profile"
  }
}

# FAIL: An omitted profile is non-compliant and exercises safe attribute access.
resource "aws_instance" "missing_iam_instance_profile" {
  expect_failure = true
  attrs = {
    ami           = "ami-12345678"
    instance_type = "t3.micro"
  }
}

# FAIL: An explicitly null profile is non-compliant.
resource "aws_instance" "null_iam_instance_profile" {
  expect_failure = true
  attrs = {
    ami                  = "ami-12345678"
    instance_type        = "t3.micro"
    iam_instance_profile = null
  }
}

# FAIL: An empty profile name is non-compliant.
resource "aws_instance" "empty_iam_instance_profile" {
  expect_failure = true
  attrs = {
    ami                  = "ami-12345678"
    instance_type        = "t3.micro"
    iam_instance_profile = ""
  }
}
