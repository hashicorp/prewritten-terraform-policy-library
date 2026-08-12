# MSK clusters should have public access disabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource not publicly accessible |

## Description

This control checks whether public access is disabled for an Amazon MSK cluster. The control fails if public access is enabled for the MSK cluster.

By default, clients can access an Amazon MSK cluster only if they're in the same VPC as the cluster. All communication between Kafka clients and an MSK cluster are private by default and streaming data doesn't traverse the internet. However, if an MSK cluster is configured to allow public access, anyone on the internet can establish a connection to Apache Kafka brokers that are running within the cluster. This can lead to issues such as unauthorized access, data breaches, or exploitation of vulnerabilities. If you restrict access to a cluster by requiring authentication and authorization measures, you can help protect sensitive information and maintain the integrity of your resources.

This rule is covered by the [msk-cluster-public-access-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/msk/msk-cluster-public-access-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # msk-cluster-public-access-disabled.policytest.hcl...
      running
      # resource.aws_msk_cluster.pass_explicit_disabled...
      running
      # resource.aws_msk_cluster.pass_explicit_disabled...
      pass
      # resource.aws_msk_cluster.pass_no_public_access_block...
      running
      # resource.aws_msk_cluster.pass_no_public_access_block...
      pass
      # resource.aws_msk_cluster.pass_no_connectivity_info...
      running
      # resource.aws_msk_cluster.pass_no_connectivity_info...
      pass
      # resource.aws_msk_cluster.fail_public_access_enabled...
      running
      # resource.aws_msk_cluster.fail_public_access_enabled...
      pass
      # msk-cluster-public-access-disabled.policytest.hcl...
      pass
```

---