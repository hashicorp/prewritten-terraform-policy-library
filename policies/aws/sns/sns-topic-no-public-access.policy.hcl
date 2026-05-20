// Policy: SNS.4 - SNS topic access policies should not allow public access

policy {}

resource_policy "aws_sns_topic_policy" "no_public_access" {
  locals {
    // Parse the policy document JSON
    policy_doc = core::jsondecode(attrs.policy)
    
    // Extract all statements for analysis
    statements = local.policy_doc.Statement
    
    // Check each statement for public access patterns
    public_statements = [
      for stmt in local.statements :
      stmt if (
        stmt.Effect == "Allow" &&
        (
          stmt.Principal == "*" ||
          core::try(stmt.Principal.AWS, "") == "*" ||
          core::try(stmt.Principal.Service, "") == "*"
        ) &&
        !core::try(stmt.Condition != null, false)
      )
    ]
    
    // Policy is compliant if no public statements found
    is_compliant = core::length(local.public_statements) == 0
  }

  enforce {
    condition = local.is_compliant
    error_message = "SNS topic policy allows public access. The policy contains ${core::length(local.public_statements)} statement(s) with wildcard (*) Principal and no restrictive conditions. Remove wildcard principals or add conditions to restrict access. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html#sns-4 for more details."
  }
}

// Additional policy to check aws_sns_topic inline policies
resource_policy "aws_sns_topic" "no_public_access_inline" {
  // Only evaluate topics that have an inline policy defined
  filter = core::try(attrs.policy, null) != null && core::try(attrs.policy, "") != ""
  
  locals {
    // Parse the inline policy document JSON
    policy_doc = core::jsondecode(attrs.policy)
    
    // Extract all statements for analysis
    statements = local.policy_doc.Statement
    
    // Check each statement for public access patterns
    public_statements = [
      for stmt in local.statements :
      stmt if (
        stmt.Effect == "Allow" &&
        (
          stmt.Principal == "*" ||
          core::try(stmt.Principal.AWS, "") == "*" ||
          core::try(stmt.Principal.Service, "") == "*"
        ) &&
        !core::try(stmt.Condition != null, false)
      )
    ]
    
    // Policy is compliant if no public statements found
    is_compliant = core::length(local.public_statements) == 0
  }

  enforce {
    condition = local.is_compliant
    error_message = "SNS topic has an inline policy that allows public access. The policy contains ${core::length(local.public_statements)} statement(s) with wildcard (*) Principal and no restrictive conditions. Remove wildcard principals or add conditions to restrict access. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html#sns-4 for more details."
  }
}