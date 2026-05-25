<<<<<<< HEAD
// Policy : SQS.3 - SQS queue access policies should not allow public access
=======
# Policy : SQS.3 - SQS queue access policies should not allow public access
>>>>>>> origin/main

policy {}

resource_policy "aws_sqs_queue_policy" "no_public_access" {
    locals {
        policy_value = core::try(attrs.policy, null)
    }
    
    filter = local.policy_value != null

    enforce {
        condition = true
        error_message = "LIMITATION: Cannot validate SQS queue policy for public access. Terraform Policy lacks JSON parsing and string pattern matching functions required to inspect policy documents. Use AWS Config rule 'sqs-queue-no-public-access' instead. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sqs-controls.html#sqs-3 for more details."
    }
}

resource_policy "aws_sqs_queue" "no_public_access_inline" {
    locals {
        policy_value = core::try(attrs.policy, null)
    }
    
    filter = local.policy_value != null

    enforce {
        condition = true
        error_message = "LIMITATION: Cannot validate SQS queue inline policy for public access. Terraform Policy lacks JSON parsing and string pattern matching functions required to inspect policy documents. Use AWS Config rule 'sqs-queue-no-public-access' instead. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sqs-controls.html#sqs-3 for more details."
    }
}
