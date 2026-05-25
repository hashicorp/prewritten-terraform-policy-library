# Application Load Balancer should be configured to redirect all HTTP requests to HTTPS

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether HTTP to HTTPS redirection is configured on all HTTP listeners of Application Load Balancers. The control fails if any of the HTTP listeners of Application Load Balancers do not have HTTP to HTTPS redirection configured.

Before you start to use your Application Load Balancer, you must add one or more listeners. A listener is a process that uses the configured protocol and port to check for connection requests. Listeners support both the HTTP and HTTPS protocols. You can use an HTTPS listener to offload the work of encryption and decryption to your load balancer. To enforce encryption in transit, you should use redirect actions with Application Load Balancers to redirect client HTTP requests to an HTTPS request on port 443.

This rule is covered by the [alb-http-to-https-redirection-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elb/alb-http-to-https-redirection-check.policy.hcl) policy.

## Policy Results

```bash
trace:
	#  alb-http-to-https-redirection-check.policytest.hcl...
	running
	# resource.aws_lb_listener.http_redirect...
	running
	# resource.aws_lb_listener.http_redirect...
	pass
	# resource.aws_lb_listener.http_no_redirect...
	running
	# resource.aws_lb_listener.http_no_redirect...
	pass
	# resource.aws_lb_listener.http_to_http...
	running
	# resource.aws_lb_listener.http_to_http...
	pass
	# resource.aws_lb_listener.http_wrong_port...
	running
	# resource.aws_lb_listener.http_wrong_port...
	pass
	# resource.aws_lb_listener.https...
	running
	# resource.aws_lb_listener.https...
	pass
	# resource.aws_lb_listener.http_8080...
	running
	# resource.aws_lb_listener.http_8080...
	pass
	#  alb-http-to-https-redirection-check.policytest.hcl...
	pass
```

---