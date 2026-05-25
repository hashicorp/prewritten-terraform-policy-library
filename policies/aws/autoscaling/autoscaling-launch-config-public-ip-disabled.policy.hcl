# Policy: Autoscaling.5 - Amazon EC2 instances launched using Auto Scaling group launch configurations should not have Public IP addresses

policy {}

resource_policy "aws_launch_configuration" "no_public_ip" {
    locals {
        # Safely extract the associate_public_ip_address attribute
        # Default to false if not specified (which is compliant)
        has_public_ip = core::try(attrs.associate_public_ip_address, false)
    }

    enforce {
        condition = local.has_public_ip == false
        error_message = "Launch configuration must not assign public IP addresses to instances. Set 'associate_public_ip_address = false' or omit the attribute. Public-facing instances should be accessed through load balancers instead of direct internet exposure. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-5 for more details."
    }
}
