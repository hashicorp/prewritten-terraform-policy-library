# CloudFormation stacks should have associated service roles

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether an AWS CloudFormation stack has a service role associated with it. The control fails for a CloudFormation stack if no service role is associated with it.

Service-managed StackSets use execution roles through AWS Organizations trusted access integration. The control also generates a FAILED finding for an AWS CloudFormation stack created by service-managed StackSets because there is no service role associated with it. Due to how service-managed StackSets authenticate, the roleARN field cannot be populated for these stacks.

Using service roles with CloudFormation stacks helps implement least privilege access by separating permissions between the user who creates/updates stacks and the permissions needed by CloudFormation to create/update resources. This reduces the risk of privilege escalation and helps maintain security boundaries between different operational roles.

It is not possible to remove a service role attached to a stack after the stack is created. Other users that have permissions to perform operations on this stack are able to use this role, regardless of whether those users have the iam:PassRole permission or not. If the role includes permissions that the user shouldn't have, you can unintentionally escalate a user's permissions. Ensure that the role grants least privilege.

This rule is covered by the [cloudformation-stack-service-role-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudformation/cloudformation-stack-service-role-check.policy.hcl) policy.


## Policy Results

```bash
trace:
	# cloudformation-stack-service-role-check.policytest.hcl...
	running
	# resource.aws_cloudformation_stack.pass_with_service_role...
	running
	# resource.aws_cloudformation_stack.pass_with_service_role...
	pass
	# resource.aws_cloudformation_stack.fail_without_service_role...
	running
	# resource.aws_cloudformation_stack.fail_without_service_role...
	pass
	# cloudformation-stack-service-role-check.policytest.hcl...
	pass
```

---
