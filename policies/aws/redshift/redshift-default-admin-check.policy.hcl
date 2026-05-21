# Redshift.8 - Amazon Redshift clusters should not use the default Admin username. This control checks whether an Amazon Redshift cluster has changed the admin username from its default value. This control will fail if the admin username for a Redshift cluster is set to awsuser.

policy {}

input "valid_admin_usernames" {
    type = string
    default = "awsuser"
}

resource_policy "aws_redshift_cluster" "default-admin-check" {
  locals {
    username = core::try(attrs.master_username, "awsuser")
    valid_admin_usernames_provided = input.valid_admin_usernames != "awsuser"
    valid_usernames = local.valid_admin_usernames_provided ? core::contains(core::split(",", input.valid_admin_usernames), local.username) : true
  }
  
  enforce {
    condition = local.username != "awsuser" && local.valid_usernames
    error_message = "Redshift cluster username is either set to default 'awsuser' value or does not match accepted list of admin usernames. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshift-controls.html#redshift-8 for more details."
  }
}