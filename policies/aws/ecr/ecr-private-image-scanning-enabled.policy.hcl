# Policy: ECR.1 - ECR private repositories should have image scanning configured

policy {}

input "ecr-private-image-scanning-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ecr_repository" "image_scanning_required" {
    enforcement_level = input.ecr-private-image-scanning-enabled-enforcement-level
    locals {
        # Safely access image_scanning_configuration block
        # Note: This is a block (not an attribute), so it's a list
        scanning_config = core::try(attrs.image_scanning_configuration, [])
        has_scanning_config = core::length(local.scanning_config) > 0
        
        # Check if scan_on_push is enabled
        scan_on_push = local.has_scanning_config ? core::try(local.scanning_config[0].scan_on_push, false) : false
    }

    enforce {
        condition = local.scan_on_push == true
        error_message = "ECR repository must have image scanning enabled. Configure 'image_scanning_configuration' block with 'scan_on_push = true' to scan images after being pushed to the repository. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecr-controls.html#ecr-1 for more details."
    }
}
