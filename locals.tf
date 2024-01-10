locals {
    allow_rules = {
        Allow_centene_internal = {
            priority = 0
            statement = {
                ip_set_reference_statement = {
                    ip_set = "centene_internal"
                }
            }
            visibility_config = {
                cloudwatch_metrics_enabledn= true
                metric_name = "centene-internal"
                sampled_requests_enabled = true
            }
        },
        Alow_US_Zscaler = {
            priority = 1
            statement = {
                ip_set_reference_statement = {
                    ip_set = "us_zscaler"
                }
            }
            visibility_config = {
                cloudwatch_metrics_enabledn= true
                metric_name = "zscaler"
                sampled_requests_enabled = true
            }
        }
    }
    block_rules = {
        Deny_centene_internal = {
            priority = 99
            statement = {
                ip_set_reference_statement = {
                    ip_set = "centene_internal"
                }
            }
            visibility_config = {
                cloudwatch_metrics_enabledn= true
                metric_name = "centene-internal"
                sampled_requests_enabled = true
            }
        },
        Alow_US_Zscaler = {
            priority = 1
            statement = {
                ip_set_reference_statement = {
                    ip_set = "us_zscaler"
                }
            }
            visibility_config = {
                cloudwatch_metrics_enabledn= true
                metric_name = "zscaler"
                sampled_requests_enabled = true
            }
        }
    }
    ip_rule_set = {
        centene_internal = {
            description = "Only allow traffic from internal centene"
            scope = "CLOUDFRONT"
            ip_address_version = "IPV4"
            address = []
        }
    }
    us_zscaler = {
        centene_internal = {
            description = "US ZScaler Ips"
            scope = "CLOUDFRONT"
            ip_address_version = "IPV4"
            address = []
        }
    }

    # ip_rule_sets = merge(local.ip_rule_sets, lookup(var.aws_wafv2, "ip_rule_sets", {}))
    # allow_all_rules = merge(local.allow_rules, lookup(var.aws_wafv2, "allow_rules", {}))
    # block_all_rules = merge(local.block_rules, lookup(var.aws_wafv2, "block_rules", {}))
}