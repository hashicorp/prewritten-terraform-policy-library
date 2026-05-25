policytest {
  targets = [
    "elb-acm-certificate-required.policy.hcl"
  ]
}
<<<<<<< HEAD
// PASS: HTTPS listener with ACM certificate
=======
# PASS: HTTPS listener with ACM certificate
>>>>>>> origin/main
resource "aws_elb" "pass_https_with_acm" {
  attrs = {
    name = "test-elb-https-acm"
    listener = [
      {
        instance_port = 443
        instance_protocol = "HTTPS"
        lb_port = 443
        lb_protocol = "HTTPS"
        ssl_certificate_id = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
      }
    ]
  }
}

<<<<<<< HEAD
// PASS: SSL listener with ACM certificate
=======
# PASS: SSL listener with ACM certificate
>>>>>>> origin/main
resource "aws_elb" "pass_ssl_with_acm" {
  attrs = {
    name = "test-elb-ssl-acm"
    listener = [
      {
        instance_port = 443
        instance_protocol = "SSL"
        lb_port = 443
        lb_protocol = "SSL"
        ssl_certificate_id = "arn:aws:acm:us-west-2:123456789012:certificate/abcdef12-3456-7890-abcd-ef1234567890"
      }
    ]
  }
}

<<<<<<< HEAD
// PASS: Multiple HTTPS/SSL listeners all with certificates
=======
# PASS: Multiple HTTPS/SSL listeners all with certificates
>>>>>>> origin/main
resource "aws_elb" "pass_multiple_listeners_all_certs" {
  attrs = {
    name = "test-elb-multi-certs"
    listener = [
      {
        instance_port = 443
        instance_protocol = "HTTPS"
        lb_port = 443
        lb_protocol = "HTTPS"
        ssl_certificate_id = "arn:aws:acm:us-east-1:123456789012:certificate/cert1"
      },
      {
        instance_port = 8443
        instance_protocol = "SSL"
        lb_port = 8443
        lb_protocol = "SSL"
        ssl_certificate_id = "arn:aws:acm:us-east-1:123456789012:certificate/cert2"
      }
    ]
  }
}

<<<<<<< HEAD
// PASS: HTTP listener only (not applicable)
=======
# PASS: HTTP listener only (not applicable)
>>>>>>> origin/main
resource "aws_elb" "pass_http_only" {
  attrs = {
    name = "test-elb-http-only"
    listener = [
      {
        instance_port = 80
        instance_protocol = "HTTP"
        lb_port = 80
        lb_protocol = "HTTP"
      }
    ]
  }
}

<<<<<<< HEAD
// PASS: TCP listener only (not applicable)
=======
# PASS: TCP listener only (not applicable)
>>>>>>> origin/main
resource "aws_elb" "pass_tcp_only" {
  attrs = {
    name = "test-elb-tcp-only"
    listener = [
      {
        instance_port = 3306
        instance_protocol = "TCP"
        lb_port = 3306
        lb_protocol = "TCP"
      }
    ]
  }
}

<<<<<<< HEAD
// FAIL: IAM certificate is not ACM-backed
=======
# FAIL: IAM certificate is not ACM-backed
>>>>>>> origin/main
resource "aws_elb" "fail_https_with_iam" {
  expect_failure = true
  attrs = {
    name = "test-elb-https-iam"
    listener = [
      {
        instance_port = 443
        instance_protocol = "HTTPS"
        lb_port = 443
        lb_protocol = "HTTPS"
        ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/my-server-cert"
      }
    ]
  }
}

<<<<<<< HEAD
// FAIL: HTTPS listener without ssl_certificate_id
=======
# FAIL: HTTPS listener without ssl_certificate_id
>>>>>>> origin/main
resource "aws_elb" "fail_https_no_cert" {
  expect_failure = true
  attrs = {
    name = "test-elb-https-no-cert"
    listener = [
      {
        instance_port = 443
        instance_protocol = "HTTPS"
        lb_port = 443
        lb_protocol = "HTTPS"
      }
    ]
  }
}

<<<<<<< HEAD
// FAIL: SSL listener without ssl_certificate_id
=======
# FAIL: SSL listener without ssl_certificate_id
>>>>>>> origin/main
resource "aws_elb" "fail_ssl_no_cert" {
  expect_failure = true
  attrs = {
    name = "test-elb-ssl-no-cert"
    listener = [
      {
        instance_port = 443
        instance_protocol = "SSL"
        lb_port = 443
        lb_protocol = "SSL"
      }
    ]
  }
}

<<<<<<< HEAD
// FAIL: Mixed listeners - one with cert, one without
=======
# FAIL: Mixed listeners - one with cert, one without
>>>>>>> origin/main
resource "aws_elb" "fail_mixed_cert_no_cert" {
  expect_failure = true
  attrs = {
    name = "test-elb-mixed"
    listener = [
      {
        instance_port = 443
        instance_protocol = "HTTPS"
        lb_port = 443
        lb_protocol = "HTTPS"
        ssl_certificate_id = "arn:aws:acm:us-east-1:123456789012:certificate/cert1"
      },
      {
        instance_port = 8443
        instance_protocol = "SSL"
        lb_port = 8443
        lb_protocol = "SSL"
      }
    ]
  }
}
