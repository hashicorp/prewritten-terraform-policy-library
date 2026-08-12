# Imported and ACM-issued certificates should be renewed after a specified time period

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an AWS Certificate Manager (ACM) certificate is renewed within the specified time period. It checks both imported certificates and certificates provided by ACM. The control fails if the certificate isn't renewed within the specified time period. Unless you provide a custom parameter value for the renewal period, Security Hub CSPM uses a default value of 30 days.

ACM can automatically renew certificates that use DNS validation. For certificates that use email validation, you must respond to a domain validation email. ACM doesn't automatically renew certificates that you import. You must renew imported certificates manually.

This rule is covered by the [acm-certificate-expiration-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/acm/acm-certificate-expiration-check.policy.hcl) policy.

## Policy Results

```bash
trace:
	# acm-certificate-expiration-check.policytest.hcl...
	running
	# resource.aws_acm_certificate.pass_eligible_for_renewal...
	running
	# resource.aws_acm_certificate.pass_eligible_for_renewal...
	pass
	# resource.aws_acm_certificate.pass_imported_certificate...
	running
	# resource.aws_acm_certificate.pass_imported_certificate...
	pass
	# resource.aws_acm_certificate.fail_needs_attention...
	running
	# resource.aws_acm_certificate.fail_needs_attention...
	pass
	# resource.aws_acm_certificate.fail_missing_expiration...
	running
	# resource.aws_acm_certificate.fail_missing_expiration...
	pass
	# resource.aws_acm_certificate.pass_pending_validation...
	running
	# resource.aws_acm_certificate.pass_pending_validation...
	pass
	# resource.aws_acm_certificate.pass_private_ca_eligible...
	running
	# resource.aws_acm_certificate.pass_private_ca_eligible...
	pass
	# acm-certificate-expiration-check.policytest.hcl...
	pass
```

---
