# Resource Relationship Policies: Design Decisions & Policy Conversion

This document independently explores syntax, evaluation semantics, relationship object models, cardinality, and implementation strategies for the proposed Optimistic Relationship RFC so that each dimension can be evaluated on its own merits.

## Background

The goal of resource relationship policies is to allow Terraform to reason about relationships between resources at plan time, rather than deferring all validation to apply time. The Optimistic Relationship RFC proposes a system for optimistically evaluating such relationships.

Designing this system requires decisions across multiple independent dimensions. Rather than combining these concerns into a single proposal, which made tradeoffs difficult to evaluate in isolation, this document separates the problem into independent design decisions:

1. Relationship declaration syntax
2. Iteration syntax
3. Relationship evaluation model
4. Cardinality model
5. Relationship traversal resolution
6. Nested relationship traversal
7. Static element filtering
8. Set-level aggregation *(unresolved)*
9. Labelled connected blocks and match-presence reference

The goal is to compare alternatives systematically rather than select a final design. That will be part of a separate document. Despite the separation, most of these decisions aren't fully independent. Where a decision constrains, or is constrained by, another decision, that's called out at the end of the relevant section.

Two scenarios are used as running examples throughout this document:

- **Flat relationship:** An `aws_s3_bucket_acl` must reference an existing `aws_s3_bucket`.
- **Nested relationship:** A CloudFront distribution must have an S3 bucket backing each S3 origin.

### Design Dimension breakdown

The goal of the system is one that:

- expresses relationships declaratively
- supports flat and nested relationships
- supports existence checks and cross-resource attribute validation
- remains compatible with optimistic evaluation
- avoids exposing incomplete collections
- remains close to existing HCL idioms where possible

---

## Design Dimension 1: Relationship declaration syntax

This dimension concerns only the keyword(s) used to declare a relationship. Some of the options are `connected`, `relationship`, `related`, `relates_to`, etc.

### Option A: `connected`

```hcl
connected "aws_s3_bucket" {
    connection {
        subject   = "bucket_id"
        connected = "id"
    }
}
```

**Pros:** short and familiar from earlier explorations.
**Cons:** the top-level `connected` collides conceptually with its nested `connection` block; unclear terminology in policy and Terraform contexts.

### Option B: `relationship`

```hcl
relationship "aws_s3_bucket" {
    match {
        subject = "bucket_id"
        target  = "id"
    }
}
```

Terminology clearly communicates intent and is explicit.

### Option C: `relates_to`

```hcl
relates_to "aws_s3_bucket" {
    match {
        subject = "bucket_id"
        target  = "id"
    }
}
```

Natural language readability.

This decision is largely independent of later semantic choices. The final design may end up being a combination of ideas from the options.

---

## Design Dimension 2: Iteration syntax

Relationships may need to express repeated or nested structures.

### Option A: dynamic iteration (`for_each`)

```hcl
connected "aws_s3_bucket" {
    for_each = local.s3_origins
    connection {
        subject = "origin[${each.index}].domain_name"
        target  = "bucket_regional_domain_name"
    }
}
```

**Pros:** familiar Terraform pattern; highly expressive.
**Cons:** no static analysis; relationship structure is dynamic.

### Option B: static iteration (`each`)

The label after `each` is a list attribute on the subject resource, i.e. `aws_s3_bucket.origin` is a list. For each element, cardinality is evaluated once, and `enforce` executes once for every matched resource.

```hcl
connected "aws_s3_bucket" {
    each "s3_origins" {
        connection {
            subject = "domain_name"
            target  = "bucket_regional_domain_name"
        }

        cardinality = "at_least_one"

        enforce {
            condition = ...
        }
    }
}
```

**Pros:** statically analyzable; relationship structure is known at plan time; simpler implementation model.
**Cons:** less expressive than full dynamic iteration; limited to subject resource attributes.

### Option C: no support for repeated structures

```hcl
connected "aws_s3_bucket" {
    connection {
        subject   = "bucket_id"
        connected = "id"
    }
}
```

**Pros:** simpler expressions, easy to reason about; statically analyzable.
**Cons:** limited to expressing only relationships to single objects; no support for repeated or nested structures.

### Option D: TBD

---

## Design Dimension 3: Relationship evaluation model

This concerns how the defined relationships are evaluated and how matched resources are exposed.

### Option A: collection-based evaluation

Matched resources are exposed as a single collection, usable in enforcement expressions.

```hcl
connected "aws_s3_bucket" {
    ...
}

enforce {
    condition = connected.aws_s3_bucket...
}
```

**Pros:** familiar collection semantics; can reason across multiple relationships; `enforce` blocks don't need to be scoped to the relationship block.
**Cons:** exposes incomplete or partial collections; cardinality becomes intertwined with enforcement; more difficult to predict under optimistic evaluation; zero-match meaning is ambiguous — no match, or no *observable* match at plan time.

### Option B: per-match evaluation

```hcl
connected "aws_s3_bucket" {
    ...
    enforce {
        condition = self.aws_s3_bucket...
    }
}
```

The `enforce` block is nested under the relationship block and evaluated for each match, with access to the matched resource via `self`.

**Pros:** compatible with optimistic evaluation; evaluation only happens if there are matches; avoids exposing partial collections.
**Cons:** no cross-relationship reasoning directly expressible; `enforce` does not execute when no match exists, so zero-match handling requires cardinality to express existence constraints (see Decision 4); multiple matches lead to multiple enforcement evaluations; requires a specialized object abstraction.

---

## Design Dimension 4: Cardinality model

Cardinality defines how many matches are valid for a relationship evaluation. Collection-based evaluation (3A) can reason about this with normal collection semantics, but per-match evaluation (3B) requires dedicated syntax — this exploration only concerns the per-match model.

### Option A: numeric constraints

```hcl
connected "aws_s3_bucket" {
    ...
    cardinality {
        min_matches   = 1
        error_message = "should be at least one"
    }

    enforce {
        condition = ...
    }
}
```

**Pros:** highly flexible and expressive bounds.
**Cons:** verbose syntax.

### Option B: semantic labels

```hcl
connected "aws_s3_bucket" {
    ...
    cardinality = "at_least_one"

    enforce {
        condition = ...
    }
}
```

Possible values: `all`, `exactly_one`, `at_most_one`, `at_least_one`.

**Pros:** readable; clear intent.
**Cons:** less flexible than numeric bounds.

Cardinality is always defined over matched resource instances for each subject. In the flat case, the constraint applies to the total number of `aws_s3_bucket` resources matched. In the nested case, the total number of evaluations grows: for each iteration of `each` (e.g. each origin element), Terraform finds matching resource instances, and `enforce` fires once per (origin element, matched resource) pair.

**Exclusion pattern:** `max_matches = 0` (or, under 4, a hypothetical `"none"` label) expresses "must not exist" — this is not a separate mechanism from existence checking, just the other end of the same numeric bound. `vpc-default-security-group-closed` uses exactly this: it asserts the default security group has no ingress/egress rules by requiring zero matches on a reverse-direction relationship (see Decision 5). Worth stating this explicitly in the spec rather than leaving it to be inferred from a single policy example.

### Cardinality scope

Cardinality is evaluated per relationship evaluation. For a flat relationship, there is one cardinality check; for an `each` relationship, cardinality is checked independently per subject element, so there is one check per iteration — never pooled across iterations. Using the earlier example:

```
origin[0] -> bucketA
origin[1] -> bucketB
origin[1] -> bucketC
```

```hcl
cardinality = {
  min_matches = 1
}
```

This passes for `origin[0]` and fails for `origin[1]`.

---

## Design Dimension 5: Relationship traversal resolution

The subject and target are assumed to be a relationship in the Terraform configuration. Terraform relationships have a direction: one resource holds a reference to another. Policies can express relationships in both directions, so a single direction isn't enough — direction is parameterized in the relationship definition.

### Outbound traversal

Terraform follows the reference held by the subject resource, e.g. find the `aws_ami` referenced by `aws_instance.ami`.

```hcl
resource_policy "aws_instance" "ami_check" {
  connected "aws_ami" {
    connection {
      direction = "outbound"
      subject   = "ami"
      target    = "id"
    }
  }
}
```

### Inbound traversal

Terraform follows the reference held by resources of the *target* type pointing back at the subject, e.g. find all `aws_flow_log` that hold a `vpc_id` reference traceable to `aws_vpc.id`.

```hcl
resource_policy "aws_vpc" "flow_logs_enabled" {
  connected "aws_flow_log" {
    connection {
      direction = "inbound"
      subject   = "vpc_id"
      target    = "id"
    }
  }
}
```

### Reference graph resolution

Connections are resolved through Terraform's internal reference graph rather than by comparing string values. This allows relationships to resolve even when target attributes are computed, provided the reference is expressed as a Terraform resource reference.

---

## Design Dimension 6: Nested relationship traversal

Relationships may require traversing through intermediate resource types.

```hcl
resource_policy "aws_lb" "multiple_az_required" {
  connected "aws_lb_listener" {
    connection {
      direction = "inbound"
      subject   = "load_balancer_arn"
      target    = "arn"
    }

    connected "aws_lb_target_group_attachment" {
      connection {
        subject = "default_action[0].target_group_arn"
        target  = "target_group_arn"
      }

      connected "aws_instance" {
        connection {
          subject = "target_id"
          target  = "id"
        }

        connected "aws_subnet" {
          connection {
            subject = "subnet_id"
            target  = "id"
          }

          enforce {
            condition = ...
          }
        }
      }
    }
  }
}
```

### Evaluation context

At every level: `self` refers to the matched resource at that level; `attrs` refers to the original policy subject. Each `enforce` executes independently for matches at its own level.

### Cardinality

Cardinality may be declared at any level and applies to matches at that hop. This results in heavily nested and complex policies for deep traversals.

---

## Design Dimension 7: Static element filtering

Individual elements of the matches often need to be filtered before enforcement evaluation. This decision concerns whether and how a static filter can be expressed on the matches.

### Option A: `where` block inside connected/relationship block

```hcl
connected "aws_s3_bucket" {
    where {
        tags = "production"
    }

    connection {
        subject = "bucket_id"
        target  = "id"
    }
}
```

The `where` block further filters matches to only those satisfying the specified conditions. For use with the pre-collected data model, values must be literals — no function calls or references to `attrs` — so expressions are statically analyzable.

**Pros:** statically evaluable by Terraform, allowing it to prune candidates before the callback; scope is unambiguous — conditions always apply to the element, not the parent resource.
**Cons:** limited to simple equality comparisons against literal values; unknown values need better-defined semantics.

### Option B: no built-in element filter

```hcl
connected "aws_s3_bucket" {
    connection {
        subject = "bucket_id"
        target  = "id"
    }

    enforce {
        condition = self.tags == "production"
    }

    enforce {
        condition = ACTUAL_CONDITION
    }
}
```

Filtering is deferred entirely to the `enforce` condition. Only matched resources that pass `enforce` contribute to a policy pass.

**Pros:** simpler syntax — no additional block needed since `enforce` already has full expression power.
**Cons:** Terraform cannot prune candidates early, all elements are iterated and all matches attempted; filtering intent is less visible — the reader must examine `enforce` to see which elements are relevant.

---

## Design Dimension 8: Set-level aggregation *(unresolved)*

Some policies require reasoning across the entire set of matched resources rather than evaluating each match independently — e.g. distinct availability zones across all matched subnets, minimum number of unique AZs, set-wide uniqueness constraints. This is the primary remaining expressive gap identified during policy conversion.

### Option A: not supported

Per-match evaluation remains the only enforcement model.

**Pros:** keeps semantics simple; preserves optimistic evaluation guarantees.
**Cons:** some existing policies can't be expressed directly; requires fallback to `getresources`-style behavior for set-level analysis.

This dimension remains intentionally unresolved.

---

## Design Dimension 9: Labelled connected blocks and match-presence reference

When a `resource_policy` declares two `connected` blocks for the same resource type, the blocks cannot be distinguished without a label. A second string label on the `connected` keyword names the block:

```hcl
connected "aws_subnet" "single_subnet" { ... }
connected "aws_subnet" "multi_subnet" { ... }
```

The label serves two purposes:

1. Allows the engine and the policy author to refer to each block independently when two blocks target the same resource type.
2. **Match-presence reference in top-level `enforce`:** a top-level `enforce` block may reference `connected.<label>.matched`, a boolean that is true if the named block produced at least one match for the current subject.

This resolves **Gap 6** for cases where the policy passes if *either* of two `connected` blocks produces a match. The per-match `enforce` inside each block still handles attribute-level checks; the top-level `enforce` handles the OR-existence condition.

### Restrictions on `connected.<label>` references in top-level `enforce`

`connected.<label>.matched` is a boolean — true if the block had at least one match — and is the *only* attribute exposed. Match count and match attributes are not accessible from the outer scope, to avoid re-introducing the collection-exposure problem of Decision 3 Option A and to keep semantics safe under optimistic evaluation.

```hcl
resource_policy "aws_eks_node_group" "emr_master_no_public_ip" {
  connected "aws_subnet" "single_subnet" {
    connection {
      subject = "ec2_attributes[0].subnet_id"
      target  = "id"
    }
    enforce {
      condition     = !self.map_public_ip_on_launch
      error_message = "..."
    }
  }

  connected "aws_subnet" "multi_subnet" {
    each "ec2_attributes[0].subnet_ids" {
      connection {
        subject = "ec2_attributes[0].subnet_ids[${each.index}]"
        target  = "id"
      }
      enforce {
        condition     = !self.map_public_ip_on_launch
        error_message = "..."
      }
    }
  }

  enforce {
    condition     = connected.single_subnet.matched || connected.multi_subnet.matched
    error_message = "EMR cluster must be launched in a VPC subnet (ec2_attributes.subnet_id or subnet_ids)"
  }
}
```

---

## Policy Conversion Index

The proposed relationship model was evaluated against existing pre-written policies that currently use `core::getresources`. The conversion exercise validates the language design, not the implementation architecture. The goal is to identify which policy patterns are expressible, which require additional language features, and which remain gapped.

### Gap definitions

**Gap 1: Traversal direction** *(resolved by Decision 5)*
Previously, reference could only be expressed in one direction, i.e the resource under policy being referenced in a related resource. Adding direction allows the reference to go the other way around.

**Gap 2: List membership joins** *(open)*
The relationship requires checking whether a subject value appears inside a list attribute on the target resource (e.g. `backup_selection.resources[]`, `subnet_group.subnet_ids`). The current model supports scalar equality joins but not membership joins.

**Gap 3: Per-element relationship expansion** *(resolved by Decision 2, Option B)*
`core::getresources` can be called inside a loop where the filter key changes per iteration. The `each` block creates one independent relationship evaluation per element of a collection, with its own connection, cardinality, and enforcement.

**Gap 4: Cross-relationship correlation** *(open)*
The policy performs two independent relationship traversals, but the final condition requires correlating the results of both — e.g. validating that an attached policy is specifically the one that was checked, not just that *a* validated policy and *a* listener both independently exist. Unsupported under per-match evaluation.

**Gap 5: Nested subject attribute paths** *(resolved by Decision 2)*
Nested and indexed attribute paths in `connection.subject` and `connection.target` (e.g. `ec2_attributes.subnet_id`).

**Gap 6: OR conditions across relationships** *(resolved by Decision 9)*
A policy may need to express "relationship A or relationship B must exist.".
Labelled `connected` blocks expose `connected.<label>.matched`, letting a top-level `enforce` reason about existence across blocks while per-match `enforce` remains scoped within each.

**Gap 7: Set-level aggregation across matches** *(open — see Decision 8)*
The enforcement condition requires reasoning across the entire set of matches (e.g. counting distinct AZs), not just each match independently. Per-match enforcement has no visibility into sibling matches. Primary unresolved language gap.

**Gap 8: Multi-hop relationship traversal** *(resolved by Decision 6)*
Previously, policies required traversing through intermediate resource types not directly related to the subject. Nested `connected` blocks let each inner relationship resolve relative to the outer relationship's matches.

---

### Fully converted policies

Grouped by pattern rather than one row per policy — most conversions are structurally identical to several others and don't need separate justification.

| Pattern                                                | Decisions used              | Policies                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| --------------------------------------------------------| -----------------------------| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Flat one-hop, forward direction                        | D1, D3B, D4                 | `ecr-private-lifecycle-policy-configured`, `s3-bucket-level-public-access-prohibited`, `s3-bucket-acl-prohibited`, `s3-bucket-ssl-requests-only`, `s3-bucket-logging-enabled`, `s3-lifecycle-policy-check`, `s3express-dir-bucket-lifecycle-rules-check`, `secretsmanager-rotation-enabled-check`, `secretsmanager-scheduled-rotation-success-check`, `docdb-cluster-encrypted-in-transit`, `custom-eventbus-policy-attached`, `route53-query-logging-enabled`, `redshift-require-tls-ssl`, `eks-nodegroup-supported-version-check`, `rds-mariadb-instance-encrypted-in-transit`, `rds-sqlserver-encrypted-in-transit`, `aurora-mysql-cluster-audit-logging`, `efs-mount-target-public-accessible` |
| Flat one-hop, reverse direction (Gap 1)                | D1, D3B, D4, D5             | `ec2-paravirtual-instance-check`, `iam-policy-no-statements-with-admin-access`, `iam-policy-no-statements-with-full-access`, `elbv2-listener-encryption-in-transit`, `vpc-flow-logs-enabled`, `ec2-instance-multiple-eni-check`                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Reverse + exclusion (`max_matches = 0`)                | D1, D3B, D4 (exclusion), D5 | `vpc-default-security-group-closed`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `each` over resource attribute (Gap 3)                 | D2B                         | `redshift-unrestricted-port-access`, `cloudfront-s3-origin-non-existent-bucket`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `for_each` over policy-defined locals (Gap 3)          | D2A                         | `vpc-endpoint-enabled`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `for_each` over policy locals + literal filter (Gap 3) | D2A, D7                     | `ec2-docker-registry-endpoint`, `ec2-vpc-ssm-endpoint`, `ec2-vpc-ssm-contacts-endpoint`, `ec2-vpc-ssm-incidents-endpoint`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Labelled blocks, OR-existence (Gap 5, Gap 6)           | D2B, D9                     | `emr-master-no-public-ip`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| No relationship needed                                 | —                           | `cloudfront-s3-origin-access-control-enabled`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |

---

### Partially converted policies — gap noted, weaker check in place

| Policy                                     | Prior gaps | Decisions   | Gap | What is lost                                                                                                                                                                                                      |
| --------------------------------------------| ------------| -------------| -----| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `elb-predefined-security-policy-ssl-check` | 4         | D1, D3B, D4 | 4  | Two `connected` blocks (`aws_elb` → `aws_load_balancer_policy`, `aws_elb` → `aws_load_balancer_listener_policy`) check independently. Does not verify the listener is wired to the compliant policy specifically. |

---

### Policies with gaps — original syntax retained

| Policy                          | Prior gaps | Decisions used so far | Root cause / remaining gap                                                                                                                                                    |
| ---------------------------------| ------------| -----------------------| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `lambda-vpc-multi-az-check`     | 2, 7       | —                     | `vpc_config[0].subnet_ids` is a list (Gap 2); final check requires distinct AZ count across all matched subnets (Gap 7)                                                       |
| `rds-instance-subnet-igw-check` | 2, 8       | D6                    | Hop chain expressible via nested `connected` (Decision 6); subnet-list membership (Gap 2) and leaf AZ aggregation (Gap 7) remain                                              |
| `efs-in-backup-plan`            | 2          | —                     | `backup_selection.resources[]` is list membership; OR condition expressible via Decision 9 once Gap 2 is resolved                                                             |
| `elbv2-multiple-az`             | 8, 7       | D6                    | Hop chain expressible via nested `connected` (Decision 6); leaf requires distinct AZ count across matched subnets (Gap 7)                                                     |
| `api-gw-associated-with-waf`    | 6          | D9                    | Composite subject path only — `connection.subject` can't be an interpolated expression; OR fallback now expressible via Decision 9 but not convertible without a subject path |


---

## Observations

- Static constructs (`each`, `where`) improve analyzability and optimization.
- Per-match evaluation provides the clearest semantic model.
- Cardinality is conceptually separate from enforcement, but its exclusion form (`max_matches = 0`) deserves an explicit callout rather than being left implicit in one policy example.
- Nested traversal resolves most multi-hop relationship cases.
- Labelled blocks with `.matched` close the OR-existence gap without reopening collection exposure.
- Set-level aggregation (Decision 8) remains the primary unresolved language gap, alongside list-membership joins (Gap 2).
- Implementation architecture can be evaluated independently once language semantics are established.
- The conversion exercise suggests most existing `getresources` policies are expressible via combinations of traversal direction, iteration, cardinality, nested traversal, and labelled blocks — remaining gaps concentrate around set-level aggregation and list-membership relationships.
