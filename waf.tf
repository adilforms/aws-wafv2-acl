# resource "aws_waf_ipset" "ipset" {
#   name = "tfIPSet"

#   ip_set_descriptors {
#     type  = "IPV4"
#     value = "192.0.7.0/24"
#   }
# }

# resource "aws_waf_rule" "wafrule" {
#   depends_on  = [aws_waf_ipset.ipset]
#   name        = "tfWAFRule"
#   metric_name = "tfWAFRule"

#   predicates {
#     data_id = aws_waf_ipset.ipset.id
#     negated = false
#     type    = "IPMatch"
#   }
# }

resource "aws_wafv2_web_acl" "waf_acl" {
    default_action{
        allow {}
    }
    dynamic "custom_rule" {
        for_each = toset(var.custom_rules)
        content {
            name = custom_rule.value.name
            priority = custom_rule.value.priority
            override_action {
            count {}
                }
        statement {
            managed_rule_group_statement {
                name = custom_rule.value.managed_rule_group_statement_name
                vendor_name = custom_rule.value.managed_rule_group_statement_vendor_name
            }
         }
        visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = custom_rule.value.metric_name
            sampled_requests_enabled   = true
         }
        }
     }
    dynamic "rule" {
        for_each = local.allow_all_rules

        content {
            name = rule.key
            priority = rule.value.priority
            action {
                allow {}
            }
            statement {
            dynamic "geo_match_statement" {
                for_each = lookup(rule.value.statement, "geo_match_statement", {})
                content {
                    country_codes = rule.statement.country_codes
                }
            }
            dynamic "ip_set_reference_statement" {
                for_each = lookup(rule.value.statement, "ip_set_reference_statement", {})
                content {
                    arn = aws.wafv2.ip_set.internal[ip_set_reference_statement.value].arn
                }
            }
            dynamic "not_statement" {
                for_each = lookup(rule.value.statement, "not_statement", {})
                content {
                    statement{
                        dynamic "ip_set_reference_statement" {
                            for_each = not_statement.value
                            content {
                                arn = aws.wafv2.ip_set.internal[ip_set_reference_statement.value].arn
                            }
                        }
                    }
                }
             }
             }
            visibility_config {
                cloudwatch_metrics_enabled = true
                metric_name                = "wafv2"
                sampled_requests_enabled   = true
             }
            }
     }
    dynamic "rule" {
        for_each = local.block_all_rules

        content {
            name = rule.key
            priority = rule.value.priority
            action {
                allow {}
            }
            statement {
            dynamic "geo_match_statement" {
                for_each = lookup(rule.value.statement, "geo_match_statement", {})
                content {
                    country_codes = rule.statement.country_codes
                }
            }
            dynamic "ip_set_reference_statement" {
                for_each = lookup(rule.value.statement, "ip_set_reference_statement", {})
                content {
                    arn = aws.wafv2.ip_set.internal[ip_set_reference_statement.value].arn
                }
            }
            dynamic "not_statement" {
                for_each = lookup(rule.value.statement, "not_statement", {})
                content {
                    statement{
                        dynamic "ip_set_reference_statement" {
                            for_each = not_statement.value
                            content {
                                arn = aws.wafv2.ip_set.internal[ip_set_reference_statement.value].arn
                            }
                        }
                    }
                }
            }
            }
            visibility_config {
            cloudwatch_metrics_enabled = true
            metric_name                = "wafv2"
            sampled_requests_enabled   = true
            }
        }
     }
     name        = "internal_spa_waf_metrics"
     description = "Internal spa waf rules"
     scope = "CLOUDFRONT"
     token_domains = null
     visibility_config {
       cloudwatch_metrics_enabled = true
       metric_name = "internal_spa_waf_metrics"
       sampled_requests_enabled = true
       }


}