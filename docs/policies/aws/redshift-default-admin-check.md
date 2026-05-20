# Amazon Redshift clusters should not use the default Admin username

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource Configuration |

## Description

This control checks whether an Amazon Redshift cluster has changed the admin username from its default value. This control will fail if the admin username for a Redshift cluster is set to awsuser.

When creating a Redshift cluster, you should change the default admin username to a unique value. Default usernames are public knowledge and should be changed upon configuration. Changing the default usernames reduces the risk of unintended access.

This rule is covered by the [redshift-default-admin-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-default-admin-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-default-admin-check.policytest.hcl... running
      # resource.aws_redshift_cluster.fail_default_awsuser... running
      # resource.aws_redshift_cluster.fail_default_awsuser... pass
      # resource.aws_redshift_cluster.fail_missing_username... running
      # resource.aws_redshift_cluster.fail_missing_username... pass
      # redshift-default-admin-check.policytest.hcl... pass
```

---
