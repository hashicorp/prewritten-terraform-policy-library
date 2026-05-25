# Service Catalog portfolios should be shared within an AWS organization only

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether AWS Service Catalog shares portfolios within an organization when the integration with AWS Organizations is enabled. The control fails if portfolios aren't shared within an organization.

Portfolio sharing only within Organizations helps ensure that a portfolio isn't shared with incorrect AWS accounts. To share a Service Catalog portfolio with an account in an organization, Security Hub CSPM recommends using ORGANIZATION_MEMBER_ACCOUNT instead of ACCOUNT. This simplifies administration by governing the access granted to the account across the organization. If you have a business need to share Service Catalog portfolios with an external account, you can automatically suppress the findings from this control or disable it.

This rule is covered by the [service-catalog-shared-within-organization](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/servicecatalog/service-catalog-shared-within-organization.policy.hcl) policy.

## Policy Results

```bash
trace:
      # service-catalog-shared-within-organization.policytest.hcl...
      running
      # resource.aws_servicecatalog_portfolio_share.pass_organization_member_account...
      running
      # resource.aws_servicecatalog_portfolio_share.pass_organization_member_account...
      pass
      # resource.aws_servicecatalog_portfolio_share.pass_organizational_unit...
      running
      # resource.aws_servicecatalog_portfolio_share.pass_organizational_unit...
      pass
      # resource.aws_servicecatalog_portfolio_share.pass_organization...
      running
      # resource.aws_servicecatalog_portfolio_share.pass_organization...
      pass
      # resource.aws_servicecatalog_portfolio_share.fail_external_account...
      running
      # resource.aws_servicecatalog_portfolio_share.fail_external_account...
      pass
      # resource.aws_servicecatalog_portfolio_share.fail_invalid_type...
      running
      # resource.aws_servicecatalog_portfolio_share.fail_invalid_type...
      pass
      # resource.aws_servicecatalog_portfolio_share.fail_missing_type...
      running
      # resource.aws_servicecatalog_portfolio_share.fail_missing_type...
      pass
      # service-catalog-shared-within-organization.policytest.hcl...
      pass
```

---