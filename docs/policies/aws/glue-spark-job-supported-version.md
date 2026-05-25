# AWS Glue Spark jobs should run on supported versions of AWS Glue

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |


## Description

## Parameters

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | ------------------------------- |
| minimumSupportedGlueVersion | Minimum supported AWS Glue version for Spark jobs. | String | Not customizable | `3.0` |
 

This control checks whether an AWS Glue for Spark job is configured to run on a supported version of AWS Glue. The control fails if the Spark job is configured to run on a version of AWS Glue that is earlier than the minimum supported version.

Only Spark ETL jobs are evaluated. Other AWS Glue job types are excluded from this version check.

This rule is covered by the [glue-spark-job-supported-version](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/glue/glue-spark-job-supported-version.policy.hcl) policy.

## Policy Results

```bash
trace:
      # glue-spark-job-supported-version.policytest.hcl...
      running
      # resource.aws_glue_job.compliant_v3...
      running
      # resource.aws_glue_job.compliant_v3...
      pass
      # resource.aws_glue_job.non_compliant_v2...
      running
      # resource.aws_glue_job.non_compliant_v2...
      pass
      # resource.aws_glue_job.missing_version...
      running
      # resource.aws_glue_job.missing_version...
      pass
      # glue-spark-job-supported-version.policytest.hcl...
      pass
```

---