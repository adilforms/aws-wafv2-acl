variable "ip_rule_sets" {
  type = any
  default = {}
}
variable "aws_wafv2_rule_group" {
    type = any
    default = {}
}
variable "custom_rules" {
  type    = list
  default = [
    {
      name = "AWS-AWSManagedRulesAdminProtectionRuleset"
      priority = 1
      managed_rule_group_statement_name = "AWSManagedRulesAdminProtectionRuleset"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name = "AWS-AWSManagedRulesAdminProtectionRuleset"
    },
    {
      name = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority = 0
      managed_rule_group_statement_name = "AWSManagedRulesAmazonIpReputationList"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name = "AWS-AWSManagedRulesAmazonIpReputationList"
    }
  ]
}