<<<<<<< HEAD
// Policy: ELB.2 - Classic Load Balancers with SSL/HTTPS listeners should use ACM certificates
=======
# Policy: ELB.2 - Classic Load Balancers with SSL/HTTPS listeners should use ACM certificates
>>>>>>> origin/main

policy {}

resource_policy "aws_elb" "acm_certificate_required" {
<<<<<<< HEAD
    // Filter to only ELBs that have listeners (skip ELBs without listeners)
=======
    # Filter to only ELBs that have listeners (skip ELBs without listeners)
>>>>>>> origin/main
    filter = attrs.listener != null && core::length(attrs.listener) > 0

    locals {
        elb_name = core::try(attrs.name, "Classic Load Balancer")

<<<<<<< HEAD
        // Stage 1: Extract all HTTPS/SSL listeners
=======
        # Stage 1: Extract all HTTPS/SSL listeners
>>>>>>> origin/main
        https_ssl_listeners = [
            for listener in attrs.listener :
            listener if core::contains(["HTTPS", "SSL"], listener.lb_protocol)
        ]

<<<<<<< HEAD
        // Stage 2: Check if ELB has any HTTPS/SSL listeners
        has_https_ssl = core::length(local.https_ssl_listeners) > 0

        // Stage 3: Check each HTTPS/SSL listener has a certificate configured
=======
        # Stage 2: Check if ELB has any HTTPS/SSL listeners
        has_https_ssl = core::length(local.https_ssl_listeners) > 0

        # Stage 3: Check each HTTPS/SSL listener has a certificate configured
>>>>>>> origin/main
        listeners_without_cert = [
            for listener in local.https_ssl_listeners :
            listener if core::try(listener.ssl_certificate_id, "") == ""
        ]

        listeners_without_acm_cert = [
            for listener in local.https_ssl_listeners :
            listener if (
                core::try(listener.ssl_certificate_id, "") != "" &&
                core::try(core::split(":", listener.ssl_certificate_id)[2], "") != "acm"
            )
        ]

<<<<<<< HEAD
        // Stage 4: Compliance check
=======
        # Stage 4: Compliance check
>>>>>>> origin/main
        has_missing_certs = core::length(local.listeners_without_cert) > 0
        has_non_acm_certs = core::length(local.listeners_without_acm_cert) > 0

        non_acm_certificate_ids = [
            for listener in local.listeners_without_acm_cert :
            core::try(listener.ssl_certificate_id, "")
        ]
    }

<<<<<<< HEAD
    // Enforce: All HTTPS/SSL listeners must have ssl_certificate_id specified
=======
    # Enforce: All HTTPS/SSL listeners must have ssl_certificate_id specified
>>>>>>> origin/main
    enforce {
        condition = !local.has_missing_certs
        error_message = "Classic Load Balancer has HTTPS/SSL listeners without ssl_certificate_id specified. All HTTPS/SSL listeners must have an ACM certificate configured. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-2 for more details."
    }

    enforce {
        condition = !local.has_non_acm_certs
        error_message = "Classic Load Balancer must use ACM certificates for HTTPS/SSL listeners. Configure certificate ARNs with the 'arn:aws:acm:' format. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-2 for more details."
    }
}