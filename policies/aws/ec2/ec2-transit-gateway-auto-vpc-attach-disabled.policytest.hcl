policytest {
    targets = [
        "ec2-transit-gateway-auto-vpc-attach-disabled.policy.hcl"
    ]
}
<<<<<<< HEAD
// Test 1: PASS - Transit Gateway with auto-accept explicitly disabled
=======
# Test 1: PASS - Transit Gateway with auto-accept explicitly disabled
>>>>>>> origin/main
resource "aws_ec2_transit_gateway" "compliant_explicit" {
    attrs = {
        auto_accept_shared_attachments = "disable"
        amazon_side_asn                = 64512
        description                    = "Transit Gateway with auto-accept disabled"
    }
}

<<<<<<< HEAD
// Test 2: PASS - Transit Gateway without auto-accept attribute (uses default)
=======
# Test 2: PASS - Transit Gateway without auto-accept attribute (uses default)
>>>>>>> origin/main
resource "aws_ec2_transit_gateway" "compliant_default" {
    attrs = {
        amazon_side_asn = 64512
        description     = "Transit Gateway using default auto-accept setting"
    }
}

<<<<<<< HEAD
// Test 3: FAIL - Transit Gateway with auto-accept enabled
=======
# Test 3: FAIL - Transit Gateway with auto-accept enabled
>>>>>>> origin/main
resource "aws_ec2_transit_gateway" "non_compliant" {
    expect_failure = true
    attrs = {
        auto_accept_shared_attachments = "enable"
        amazon_side_asn                = 64512
        description                    = "Transit Gateway with auto-accept enabled"
    }
}
