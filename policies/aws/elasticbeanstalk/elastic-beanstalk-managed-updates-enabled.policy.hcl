# Copyright IBM Corp. 2026

# ElasticBeanstalk.2: Elastic Beanstalk managed platform updates should be enabled

policy {}

input "UpdateLevel" {
    type = string
    default = ""
}

resource_policy "aws_elastic_beanstalk_environment" "managed_updates_enabled" {
    locals {

        # Extract all settings from the environment configuration
        all_settings = core::try(attrs.setting, [])
        env_name = core::try(attrs.name, "Elastic Beanstalk environment")
        
        # Find the managed actions settings
        managed_action_settings = [
            for s in local.all_settings :
            s if s.namespace == "aws:elasticbeanstalk:managedactions"
        ]
        
        # Check if ManagedActionsEnabled is set to true
        enabled_settings = [
            for s in local.managed_action_settings :
            s if s.name == "ManagedActionsEnabled" && s.value == "true"
        ]
        
        # Determine if managed updates are enabled
        managed_updates_enabled = core::length(local.enabled_settings) > 0
        
        # Extract update level settings for optional validation
        update_level_settings = [
            for s in local.all_settings :
            s if s.namespace == "aws:elasticbeanstalk:managedactions:platformupdate" && 
                 s.name == "UpdateLevel"
        ]
        
        # Get the configured update level (if any)
        update_level = core::length(local.update_level_settings) > 0 ? local.update_level_settings[0].value : ""

        update_level_configured = input.UpdateLevel != ""
        update_level_allowed = !local.update_level_configured || core::contains(["minor", "patch"], input.UpdateLevel)
        update_level_matches = !local.update_level_configured || local.update_level == input.UpdateLevel
    }

    enforce {
        condition = local.managed_updates_enabled
        error_message = "Elastic Beanstalk environment '${local.env_name}' must have managed platform updates enabled. Set 'ManagedActionsEnabled' to 'true' in the 'aws:elasticbeanstalk:managedactions' namespace. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticbeanstalk-controls.html#elasticbeanstalk-2 for more details."
    }

    enforce {
        condition = local.update_level_allowed
        error_message = "Elastic Beanstalk managed updates input UpdateLevel must be either 'minor' or 'patch' when configured. Current input value: '${input.UpdateLevel}'."
    }

    enforce {
        condition = local.update_level_matches
        error_message = "Elastic Beanstalk environment '${local.env_name}' must set UpdateLevel = '${input.UpdateLevel}' in the 'aws:elasticbeanstalk:managedactions:platformupdate' namespace when the input is configured. Current value: '${local.update_level}'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticbeanstalk-controls.html#elasticbeanstalk-2 for more details."
    }
}
