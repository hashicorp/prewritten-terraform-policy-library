# ECR private repositories should have tag immutability configured

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Tagging |

## Description

This control checks whether a private ECR repository has tag immutability enabled. This control fails if a private ECR repository has tag immutability disabled. This rule passes if tag immutability is enabled and has the value IMMUTABLE.

Amazon ECR Tag Immutability enables customers to rely on the descriptive tags of an image as a reliable mechanism to track and uniquely identify images. An immutable tag is static, which means each tag refers to a unique image. This improves reliability and scalability as the use of a static tag will always result in the same image being deployed. When configured, tag immutability prevents the tags from being overridden, which reduces the attack surface.

This rule is covered by the [ecr-private-tag-immutability-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ecr/ecr-private-tag-immutability-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecr-private-tag-immutability-enabled.policytest.hcl...
      running
      # resource.aws_ecr_repository.immutable_pass...
      running
      # resource.aws_ecr_repository.immutable_pass...
      pass
      # resource.aws_ecr_repository.mutable_fail...
      running
      # resource.aws_ecr_repository.mutable_fail...
      pass
      # resource.aws_ecr_repository.immutable_with_exclusion_fail...
      running
      # resource.aws_ecr_repository.immutable_with_exclusion_fail...
      pass
      # resource.aws_ecr_repository.missing_mutability_fail...
      running
      # resource.aws_ecr_repository.missing_mutability_fail...
      pass
      # ecr-private-tag-immutability-enabled.policytest.hcl...
      pass
```

---
