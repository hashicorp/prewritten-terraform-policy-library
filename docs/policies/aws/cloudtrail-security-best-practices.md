# At least one CloudTrail trail should be defined with security best practices

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This policy checks that there is at least one AWS CloudTrail trail defined with security best practices. The policy passes if there is at least one trail that meets all of the following:

The policy evaluates `aws_cloudtrail` resources.

This rule is covered by the [cloudtrail-security-best-practices](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudtrail/cloudtrail-security-best-practices.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      cloudtrail-security-best-practices.policytest.hcl...
      running
      # resource.aws_cloudtrail.pass_fully_compliant_default...
      running
      # resource.aws_cloudtrail.pass_fully_compliant_default...
      pass
      #
      resource.aws_cloudtrail.pass_logging_null_defaults_true...
      running
      #
      resource.aws_cloudtrail.pass_logging_null_defaults_true...
      pass
      # resource.aws_cloudtrail.pass_basic_selector_all...
      running
      # resource.aws_cloudtrail.pass_basic_selector_all...
      pass
      #
      resource.aws_cloudtrail.pass_basic_selector_read_and_write...
      running
      #
      resource.aws_cloudtrail.pass_basic_selector_read_and_write...
      pass
      #
      resource.aws_cloudtrail.pass_advanced_selector_full_coverage...
      running
      #
      resource.aws_cloudtrail.pass_advanced_selector_full_coverage...
      pass
      #
      resource.aws_cloudtrail.pass_advanced_selector_read_and_write...
      running
      #
      resource.aws_cloudtrail.pass_advanced_selector_read_and_write...
      pass
      #
      resource.aws_cloudtrail.pass_noncompliant_trail_alongside_compliant...
      running
      #
      resource.aws_cloudtrail.pass_noncompliant_trail_alongside_compliant...
      pass
      #
      cloudtrail-security-best-practices.policytest.hcl...
      pass
```

---
