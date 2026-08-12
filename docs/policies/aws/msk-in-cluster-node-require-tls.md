# MSK clusters should be encrypted in transit among broker nodes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description
This controls checks whether an Amazon MSK cluster is encrypted in transit with HTTPS (TLS) among the broker nodes of the cluster. The control fails if plain text communication is enabled for a cluster broker node connection.

HTTPS offers an extra layer of security as it uses TLS to move data and can be used to help prevent potential attackers from using person-in-the-middle or similar attacks to eavesdrop on or manipulate network traffic. By default, Amazon MSK encrypts data in transit with TLS. However, you can override this default at the time that you create the cluster. We recommend using encrypted connections over HTTPS (TLS) for-broker node connections.

This rule is covered by the [msk-in-cluster-node-require-tls](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/msk/msk-in-cluster-node-require-tls.policy.hcl) policy.

## Policy Results

```bash
trace:
      # msk-in-cluster-node-require-tls.policytest.hcl...
      running
      # resource.aws_msk_cluster.pass_no_encryption_info_block...
      running
      # resource.aws_msk_cluster.pass_no_encryption_info_block...
      pass
      # resource.aws_msk_cluster.pass_no_encryption_in_transit_block...
      running
      # resource.aws_msk_cluster.pass_no_encryption_in_transit_block...
      pass
      # resource.aws_msk_cluster.pass_in_cluster_true...
      running
      # resource.aws_msk_cluster.pass_in_cluster_true...
      pass
      # resource.aws_msk_cluster.fail_in_cluster_false...
      running
      # resource.aws_msk_cluster.fail_in_cluster_false...
      pass
      # resource.aws_msk_cluster.pass_in_cluster_not_specified...
      running
      # resource.aws_msk_cluster.pass_in_cluster_not_specified...
      pass
      # resource.aws_msk_cluster.pass_full_encryption_config...
      running
      # resource.aws_msk_cluster.pass_full_encryption_config...
      pass
      # msk-in-cluster-node-require-tls.policytest.hcl...
      pass
```

---
