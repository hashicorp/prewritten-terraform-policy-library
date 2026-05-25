<<<<<<< HEAD
// Policy: WAF.10 - AWS WAF web ACLs should have at least one rule or rule group
=======
# Policy: WAF.10 - AWS WAF web ACLs should have at least one rule or rule group
>>>>>>> origin/main

policy {}

resource_policy "aws_wafv2_web_acl" "waf10_webacl_not_empty" {
    locals {
<<<<<<< HEAD
        // Safely get the rule attribute, defaulting to empty list if not present
        rules = core::try(attrs.rule, [])
        
        // Check if at least one rule exists
=======
        # Safely get the rule attribute, defaulting to empty list if not present
        rules = core::try(attrs.rule, [])
        
        # Check if at least one rule exists
>>>>>>> origin/main
        has_rules = core::length(local.rules) > 0
    }

    enforce {
        condition = local.has_rules
        error_message = "WAF.10 violation: Web ACL must have at least one rule or rule group. A web ACL should contain a collection of rules and rule groups that inspect and control web requests. If a web ACL is empty, the web traffic can pass without being detected or acted upon by AWS WAF depending on the default action. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-10 for more details."
    }
}
