output "aws_lb_nlb_arn" {
  value = length(local.settings.nlb.configurations) > 0 ? aws_lb.nlb[0].arn : ""
}

output "aws_lb_nlb_dns" {
  value = length(local.settings.nlb.configurations) > 0 ? aws_lb.nlb[0].dns_name : ""
}

output "data_aws_subnets_filter_first_id" {
  value = data.aws_subnets.filter.ids[0]
}


output "aws_lb_application_arn" {
  value = length(local.settings.alb.listeners) > 0 ? aws_lb.alb[0].arn : ""
}

output "aws_lb_application_dns" {
  value = length(local.settings.alb.listeners) > 0 ? aws_lb.alb[0].dns_name : ""
}

output "module_ec2_instance_id" {
  value = module.ec2-instance-base.id
}
