output "aws_lb_nlb_arn" {
  value = length(local.settings.nlb_configurations) > 0 ? aws_lb.nlb[0].arn : ""
}

output "aws_lb_nlb_dns" {
  value = length(local.settings.nlb_configurations) > 0 ? aws_lb.nlb[0].dns_name : ""
}

output "data_aws_subnets_filter_first_id" {
  value = data.aws_subnets.filter.ids[0]
}
