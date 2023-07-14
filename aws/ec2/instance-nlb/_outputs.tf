output "aws_lb_network_arn" {
  value = aws_lb.network.arn
}

output "aws_lb_network_dns" {
  value = aws_lb.network.dns_name
}

output "data_aws_subnets_filter_first_id" {
  value = data.aws_subnets.filter.ids[0]
}