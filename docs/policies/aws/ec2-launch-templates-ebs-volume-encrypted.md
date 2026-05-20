# EC2 launch templates should enable encryption for attached EBS volumes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon EC2 launch template enables encryption for all attached EBS volumes. The control fails if the encryption parameter is set to False for any EBS volumes specified by the EC2 launch template.

Amazon EBS encryption is a straightforward encryption solution for EBS resources that are associated with Amazon EC2 instances. With EBS encryption, you aren't required to build, maintain, and secure your own key management infrastructure. EBS encryption uses AWS KMS keys when creating encrypted volumes and snapshots. Encryption operations occur on the servers that host EC2 instances, which helps ensure the security of data at rest and data in transit between an EC2 instance and its attached EBS storage. For more information, see Amazon EBS encryption in the Amazon EBS User Guide.

You can enable EBS encryption during manual launches of individual EC2 instances. However, there are several benefits to using EC2 launch templates and configuring encryption settings in those templates. You can enforce encryption as a standard and ensure the use of consistent encryption settings. You can also reduce the risk of error and security gaps that might occur with manual launches of instances.

When this control checks an EC2 launch template, it only evaluates EBS encryption settings that are explicitly specified by the template. The evaluation doesn’t include encryption settings that are inherited from account-level EBS encryption settings, AMI block device mappings, or source snapshot encryption statuses.

This rule is covered by the [ec2-launch-templates-ebs-volume-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-launch-templates-ebs-volume-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-launch-templates-ebs-volume-encrypted.policytest.hcl... running
      # resource.aws_launch_template.pass_single_volume_encrypted... running
      # resource.aws_launch_template.pass_single_volume_encrypted... pass
      # resource.aws_launch_template.fail_single_volume_not_encrypted... running
      # resource.aws_launch_template.fail_single_volume_not_encrypted... pass
      # resource.aws_launch_template.fail_single_volume_encryption_not_specified... running
      # resource.aws_launch_template.fail_single_volume_encryption_not_specified... pass
      # resource.aws_launch_template.pass_multiple_volumes_all_encrypted... running
      # resource.aws_launch_template.pass_multiple_volumes_all_encrypted... pass
      # resource.aws_launch_template.fail_multiple_volumes_mixed_encryption... running
      # resource.aws_launch_template.fail_multiple_volumes_mixed_encryption... pass
      # resource.aws_launch_template.fail_multiple_volumes_some_missing_encryption... running
      # resource.aws_launch_template.fail_multiple_volumes_some_missing_encryption... pass
      # resource.aws_launch_template.pass_no_block_device_mappings... running
      # resource.aws_launch_template.pass_no_block_device_mappings... pass
      # resource.aws_launch_template.pass_block_mappings_no_ebs... running
      # resource.aws_launch_template.pass_block_mappings_no_ebs... pass
      # resource.aws_launch_template.pass_encrypted_with_kms_key... running
      # resource.aws_launch_template.pass_encrypted_with_kms_key... pass
      # ec2-launch-templates-ebs-volume-encrypted.policytest.hcl... pass
```

---
