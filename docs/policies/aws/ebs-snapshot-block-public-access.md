# Block public access settings should be enabled for Amazon EBS snapshots

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether account level block public access is enabled to prevent sharing of Amazon EBS snapshots to all. The control fails if block public access is not enabled to block sharing of Amazon EBS snapshots to all.

To prevent public sharing of your Amazon EBS snapshots, you can enable block public access for snapshots. Once block public access for snapshots is enabled in a Region, any attempt to publicly share snapshots in that Region is automatically blocked. This helps improve the security of the snapshots and protect the snapshot data from unauthorized or unintended access.

This rule is covered by the [ebs-snapshot-block-public-access](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ebs-snapshot-block-public-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ebs-snapshot-block-public-access.policytest.hcl... running
      # resource.aws_ebs_snapshot_block_public_access.pass_with_block_all_sharing... running
      # resource.aws_ebs_snapshot_block_public_access.pass_with_block_all_sharing... pass
      # resource.aws_ebs_snapshot_block_public_access.fail_with_block_new_sharing... running
      # resource.aws_ebs_snapshot_block_public_access.fail_with_block_new_sharing... pass
      # resource.aws_ebs_snapshot_block_public_access.fail_with_unblocked... running
      # resource.aws_ebs_snapshot_block_public_access.fail_with_unblocked... pass
      # resource.aws_ebs_snapshot_block_public_access.fail_with_missing_state... running
      # resource.aws_ebs_snapshot_block_public_access.fail_with_missing_state... pass
      # ebs-snapshot-block-public-access.policytest.hcl... pass
```

---
