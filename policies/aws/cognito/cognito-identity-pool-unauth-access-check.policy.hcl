# Copyright IBM Corp. 2026

# Policy : Cognito.2 - Cognito identity pools should not allow unauthenticated identities

policy {}

resource_policy "aws_cognito_identity_pool" "no_unauthenticated_access" {
    # Safe access to the allow_unauthenticated_identities attribute
    # Default to true (fail-safe) if attribute doesn't exist
    locals {
        allows_unauth = core::try(attrs.allow_unauthenticated_identities, true)
    }

    # Enforce that unauthenticated identities are not allowed
    enforce {
        condition = local.allows_unauth == false
        error_message = "Cognito identity pool must not allow unauthenticated identities. Set 'allow_unauthenticated_identities' to false. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cognito-controls.html#cognito-2 for more details."
    }
}
