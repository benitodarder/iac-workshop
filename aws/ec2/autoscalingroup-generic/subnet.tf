data "aws_subnets" "filter" {
  filter {
    name   = local.settings.subnet_filter_criteria
    values = local.settings.subnet_filter_values
  }
}