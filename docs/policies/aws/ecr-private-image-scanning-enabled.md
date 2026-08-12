# ECR private repositories should have image scanning configured

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether a private Amazon ECR repository has image scanning configured. The control fails if the private ECR repository isn't configured for scan on push or continuous scanning.

ECR image scanning helps in identifying software vulnerabilities in your container images. Configuring image scanning on ECR repositories adds a layer of verification for the integrity and safety of the images being stored.

This rule is covered by the [ecr-private-image-scanning-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecr/ecr-private-image-scanning-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecr-private-image-scanning-enabled.policytest.hcl...
      running
      # resource.aws_ecr_repository.compliant...
      running
      # resource.aws_ecr_repository.compliant...
      pass
      # resource.aws_ecr_repository.non_compliant...
      running
      # resource.aws_ecr_repository.non_compliant...
      pass
      # resource.aws_ecr_repository.disabled_scanning...
      running
      # resource.aws_ecr_repository.disabled_scanning...
      pass
      # ecr-private-image-scanning-enabled.policytest.hcl...
      pass
```

---
