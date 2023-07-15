output "aws_elb_network_arn" {
  value = aws_elb.network.arn
}

output "aws_elb_network_dns" {
  value = aws_elb.network.dns_name
}

output "data_aws_subnets_filter_first_id" {
  value = data.aws_subnets.filter.ids[0]
}