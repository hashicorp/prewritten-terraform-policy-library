# WorkSpaces.2 - WorkSpaces root volumes should be encrypted at rest.

policy {}

resource_policy "aws_workspaces_workspace" "root-volume-encrypted" {
    enforce {
        condition = core::try(attrs.root_volume_encryption_enabled, false)
        error_message = "The WorkSpaces root volume is not encrypted at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/workspaces-controls.html#workspaces-2 for more details."
    }
}
