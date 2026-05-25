# AWS AppSync should have field-level logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

fieldLoggingLevel

Field logging level

Enum

ERROR, ALL, INFO, DEBUG

No default value

This control checks whether an AWS AppSync API has field-level logging turned on. The control fails if the field resolver log level is set to None. Unless you provide custom parameter values to indicate that a specific log type should be enabled, Security Hub CSPM produces a passed finding if the field resolver log level is either ERROR or ALL.

You can use logging and metrics to identify, troubleshoot, and optimize your GraphQL queries. Turning on logging for AWS AppSync GraphQL helps you get detailed information about API requests and responses, identify and respond to issues, and comply with regulatory requirements.

This rule is covered by the [appsync-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/appsync/appsync-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# appsync-logging-enabled.policytest.hcl...
	running
	# resource.aws_appsync_graphql_api.valid_error_logging...
	running
	# resource.aws_appsync_graphql_api.valid_error_logging...
	pass
	# resource.aws_appsync_graphql_api.valid_all_logging...
	running
	# resource.aws_appsync_graphql_api.valid_all_logging...
	pass
	# resource.aws_appsync_graphql_api.invalid_no_logs...
	running
	# resource.aws_appsync_graphql_api.invalid_no_logs...
	pass
	# resource.aws_appsync_graphql_api.invalid_field_without_verbose...
	running
	# resource.aws_appsync_graphql_api.invalid_field_without_verbose...
	pass
	# resource.aws_appsync_graphql_api.invalid_resolver_without_verbose...
	running
	# resource.aws_appsync_graphql_api.invalid_resolver_without_verbose...
	pass
	# appsync-logging-enabled.policytest.hcl...
	pass
```

---