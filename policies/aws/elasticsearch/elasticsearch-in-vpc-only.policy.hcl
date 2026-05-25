# ES.2 - Elasticsearch domains should not be publicly accessible.

policy {}

resource_policy "aws_elasticsearch_domain" "vpc_only" {
    locals {
        vpc_options = core::try(attrs.vpc_options, [])
        has_vpc_options = core::length(local.vpc_options) > 0
        subnet_ids = local.has_vpc_options ? core::try(local.vpc_options[0].subnet_ids, []) : []
        has_subnets = core::length(local.subnet_ids) > 0
    }

    enforce {
        condition = local.has_vpc_options
        error_message = "Elasticsearch domain must be deployed within a VPC. Add 'vpc_options' block with 'subnet_ids' to place the domain in a VPC and prevent public internet access. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/es-controls.html#es-2 for more details."
    }

    enforce {
        condition = local.has_subnets
        error_message = "Elasticsearch domain has vpc_options but no subnet_ids configured. Specify at least one subnet_id in vpc_options.subnet_ids to deploy the domain within a VPC. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/es-controls.html#es-2 for more details."
    }
}
