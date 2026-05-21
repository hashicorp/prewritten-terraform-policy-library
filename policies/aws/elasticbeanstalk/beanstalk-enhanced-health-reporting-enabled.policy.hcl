# ElasticBeanstalk.1: Enhanced Health Reporting Required

policy {}

resource_policy "aws_elastic_beanstalk_environment" "enhanced_health_reporting_required" {
  
  locals {
    # Extract all health reporting system type settings
    health_reporting_settings = [
      for setting in core::try(attrs.setting, []) :
      setting if core::try(setting.namespace, "") == "aws:elasticbeanstalk:healthreporting:system" &&
                 core::try(setting.name, "") == "SystemType"
    ]
    
    # Check if enhanced health reporting is configured
    has_enhanced_health = core::length(local.health_reporting_settings) > 0 ? (
      core::try(local.health_reporting_settings[0].value, "") == "enhanced"
    ) : false
    
    # Environment name for error messages
    env_name = core::try(attrs.name, "Elastic Beanstalk environment")
  }
  
  enforce {
    condition = local.has_enhanced_health
    error_message = "Elastic Beanstalk environment '${local.env_name}' must have enhanced health reporting enabled. Configure setting with namespace='aws:elasticbeanstalk:healthreporting:system', name='SystemType', value='enhanced'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticbeanstalk-controls.html#elasticbeanstalk-1 for more details."
  }
}
