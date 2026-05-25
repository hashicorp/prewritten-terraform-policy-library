<<<<<<< HEAD
// Policy: ELB.7 - Classic Load Balancers should have connection draining enabled
=======
# Policy: ELB.7 - Classic Load Balancers should have connection draining enabled
>>>>>>> origin/main

policy {}

resource_policy "aws_elb" "connection_draining_enabled" {
    locals {
<<<<<<< HEAD
        // Safe access to connection_draining attribute with default false
        // (matches AWS provider default behavior)
=======
        # Safe access to connection_draining attribute with default false
        # (matches AWS provider default behavior)
>>>>>>> origin/main
        connection_draining = core::try(attrs.connection_draining, false)
        elb_name = core::try(attrs.name, "Classic Load Balancer")
    }

    enforce {
        condition     = local.connection_draining == true
        error_message = "Classic Load Balancer '${local.elb_name}' must have connection draining enabled. Set 'connection_draining = true' in the resource configuration to ensure graceful handling of de-registering instances. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-7 for more details."
    }
}
