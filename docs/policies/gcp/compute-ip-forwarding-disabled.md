# Ensure That IP Forwarding Is Not Enabled on Instances

| Provider | Category |
| -------- | -------- |
| Google Cloud Platform | Compute security |

## Description

This control checks that `can_ip_forward` is either omitted (which the provider defaults to `false`) or explicitly set to `false` on a `google_compute_instance`.

IP forwarding allows an instance to send and receive packets with a source or destination other than its own, effectively letting it act as a router, NAT gateway, or VPN endpoint. When IP forwarding is enabled without a deliberate networking purpose, it can be used to bypass network segmentation and firewall boundaries that assume instances only originate traffic for themselves, expanding the paths an attacker on a compromised instance could use to pivot to other systems. IP forwarding should only be enabled on instances that are intentionally deployed as routing or NAT appliances.

This rule is covered by the [compute-ip-forwarding-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/gcp/compute/compute-ip-forwarding-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
   # compute-ip-forwarding-disabled.policytest.hcl...
   running
   # resource.google_compute_instance.pass_can_ip_forward_omitted...
   running
   # resource.google_compute_instance.pass_can_ip_forward_omitted...
   pass
   # resource.google_compute_instance.pass_can_ip_forward_false...
   running
   # resource.google_compute_instance.pass_can_ip_forward_false...
   pass
   # resource.google_compute_instance.pass_can_ip_forward_null...
   running
   # resource.google_compute_instance.pass_can_ip_forward_null...
   pass
   # resource.google_compute_instance.fail_can_ip_forward_true...
   running
   # resource.google_compute_instance.fail_can_ip_forward_true...
   pass
   # compute-ip-forwarding-disabled.policytest.hcl...
   pass
```

---
