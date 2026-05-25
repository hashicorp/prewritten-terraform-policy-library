# Elastic Beanstalk environments should have enhanced health reporting enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Application monitoring |

## Description

This control checks whether enhanced health reporting is enabled for your AWS Elastic Beanstalk environments.

Elastic Beanstalk enhanced health reporting enables a more rapid response to changes in the health of the underlying infrastructure. These changes could result in a lack of availability of the application.

Elastic Beanstalk enhanced health reporting provides a status descriptor to gauge the severity of the identified issues and identify possible causes to investigate. The Elastic Beanstalk health agent, included in supported Amazon Machine Images (AMIs), evaluates logs and metrics of environment EC2 instances.

This rule is covered by the [beanstalk-enhanced-health-reporting-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticbeanstalk/beanstalk-enhanced-health-reporting-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# beanstalk-enhanced-health-reporting-enabled.policytest.hcl...
	running
	# resource.aws_elastic_beanstalk_environment.pass_enhanced_health...
	running
	# resource.aws_elastic_beanstalk_environment.pass_enhanced_health...
	pass
	# resource.aws_elastic_beanstalk_environment.fail_basic_health...
	running
	# resource.aws_elastic_beanstalk_environment.fail_basic_health...
	pass
	# resource.aws_elastic_beanstalk_environment.fail_missing_setting...
	running
	# resource.aws_elastic_beanstalk_environment.fail_missing_setting...
	pass
	# beanstalk-enhanced-health-reporting-enabled.policytest.hcl...
	pass
```

---