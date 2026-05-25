# CloudFormation.4: CloudFormation stacks should have associated service roles

policy {}

resource_policy "aws_cloudformation_stack" "service_role_required" {
    locals {
        # Safely extract the iam_role_arn attribute
        iam_role_arn = core::try(attrs.iam_role_arn, null)
        
        # Check if service role is configured
        has_service_role = local.iam_role_arn != null && local.iam_role_arn != ""
    }

    enforce {
        condition     = local.has_service_role
        error_message = "CloudFormation stack must have a service role associated. Set the 'iam_role_arn' attribute to an IAM role ARN that AWS CloudFormation can assume to create the stack. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudformation-controls.html#cloudformation-4 for more details. "
    }
}