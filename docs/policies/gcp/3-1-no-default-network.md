# Ensure That the Default Network Does Not Exist in a Project

| Provider | Category |
| -------- | -------- |
| Google Cloud Platform | Network security |

## Description

This control checks that a `google_compute_network` is not named `default`, and that a `google_project` does not leave `auto_create_network` at its provider default of `true` (which silently creates the default network without ever declaring a `google_compute_network` resource).

Every new GCP project automatically provisions a `default` network with pre-configured firewall rules that allow inbound SSH, RDP, ICMP, and inter-instance traffic from any source. These permissive default rules are intended to make getting started easy, not to reflect a secure baseline, and they are easy to overlook since they exist without any explicit action from the project owner — including through `google_project.auto_create_network`, which defaults to `true` and provisions the default network even when no `google_compute_network` resource is ever authored. Deleting the `default` network and replacing it with a custom-mode VPC network with explicitly authored (least-privilege) firewall rules, and setting `auto_create_network = false` on every `google_project`, ensures network access is deliberately scoped rather than inherited from an insecure default.

This rule is covered by the [3-1-no-default-network](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/gcp/network/3-1-no-default-network.policy.hcl) policy.

## Policy Results

```bash
trace:
   # 3-1-no-default-network.policytest.hcl... 
   running
   # resource.google_compute_network.custom_network_passes... 
   running
   # resource.google_compute_network.custom_network_passes... 
   pass
   # resource.google_compute_network.default_network_fails... 
   running
   # resource.google_compute_network.default_network_fails... 
   pass
   # resource.google_project.auto_create_network_false_passes... 
   running
   # resource.google_project.auto_create_network_false_passes... 
   pass
   # resource.google_project.auto_create_network_true_fails... 
   running
   # resource.google_project.auto_create_network_true_fails... 
   pass
   # resource.google_project.auto_create_network_omitted_fails... 
   running
   # resource.google_project.auto_create_network_omitted_fails... 
   pass
   # 3-1-no-default-network.policytest.hcl... 
   pass
```

---
