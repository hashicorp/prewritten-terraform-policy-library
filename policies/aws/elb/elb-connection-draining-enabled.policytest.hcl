policytest {
  targets = ["elb-connection-draining-enabled.policy.hcl"]
}

<<<<<<< HEAD
// Test 1: PASS - Connection draining explicitly enabled
=======
# Test 1: PASS - Connection draining explicitly enabled
>>>>>>> origin/main
resource "aws_elb" "compliant" {
  attrs = {
    name                        = "compliant-elb"
    availability_zones          = ["us-east-1a", "us-east-1b"]
    connection_draining         = true
    connection_draining_timeout = 300
    listener = [
      {
        instance_port     = 80
        instance_protocol = "HTTP"
        lb_port           = 80
        lb_protocol       = "HTTP"
      }
    ]
  }
}

<<<<<<< HEAD
// Test 2: FAIL - Connection draining explicitly disabled
=======
# Test 2: FAIL - Connection draining explicitly disabled
>>>>>>> origin/main
resource "aws_elb" "non_compliant_disabled" {
  expect_failure = true
  attrs = {
    name                        = "non-compliant-elb"
    availability_zones          = ["us-east-1a", "us-east-1b"]
    connection_draining         = false
    listener = [
      {
        instance_port     = 80
        instance_protocol = "HTTP"
        lb_port           = 80
        lb_protocol       = "HTTP"
      }
    ]
  }
}

<<<<<<< HEAD
// Test 3: FAIL - Connection draining not specified (defaults to false)
=======
# Test 3: FAIL - Connection draining not specified (defaults to false)
>>>>>>> origin/main
resource "aws_elb" "non_compliant_default" {
  expect_failure = true
  attrs = {
    name               = "default-elb"
    availability_zones = ["us-east-1a", "us-east-1b"]
    listener = [
      {
        instance_port     = 80
        instance_protocol = "HTTP"
        lb_port           = 80
        lb_protocol       = "HTTP"
      }
    ]
<<<<<<< HEAD
    // connection_draining not specified - defaults to false
=======
    # connection_draining not specified - defaults to false
>>>>>>> origin/main
  }
}