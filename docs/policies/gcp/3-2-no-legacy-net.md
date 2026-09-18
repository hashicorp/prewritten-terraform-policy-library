# Ensure Legacy Networks Do Not Exist for Older Projects

| Provider | Category |
| -------- | -------- |
| Google Cloud Platform | Network security |

## Description

This control checks that a `google_compute_network` does not have a non-empty `gateway_ipv4` attribute, since legacy (non-subnetted, single global IP range) networks expose a network-wide gateway IP, whereas modern VPC networks with regional subnets do not.

Legacy networks predate GCP's regional subnet model and route all instances through a single, project-wide IP range and gateway, which prevents the network isolation that regional subnets and custom firewall rules are designed to provide. The current `google_compute_network` resource no longer exposes any argument capable of creating a legacy network (the historical `ipv4_range`/`IPv4Range` argument has been removed from the provider schema), so this check can only ever be meaningfully violated by a pre-existing legacy network — created outside Terraform or with a much older provider version — being brought under management. Note also that `gateway_ipv4` is a computed, output-only attribute: for a network being newly created, it is unresolved ("known after apply") rather than empty, so this control is only actionable once the attribute has been resolved from real state (for example, when auditing or updating an already-existing network).

This rule is covered by the [3-2-no-legacy-net](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/gcp/network/3-2-no-legacy-net.policy.hcl) policy.

## Policy Results

```bash
trace:
   # 3-2-no-legacy-net.policytest.hcl... 
   running
   # resource.google_compute_network.pass_auto_subnet_mode... 
   running
   # resource.google_compute_network.pass_auto_subnet_mode... 
   pass
   # resource.google_compute_network.pass_custom_subnet_mode... 
   running
   # resource.google_compute_network.pass_custom_subnet_mode... 
   pass
   # resource.google_compute_network.fail_legacy_network... 
   running
   # resource.google_compute_network.fail_legacy_network... 
   pass
   # 3-2-no-legacy-net.policytest.hcl... 
   pass
```

---
