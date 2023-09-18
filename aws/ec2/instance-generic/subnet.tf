data "aws_subnets" "filter" {
  filter {
    name   = local.settings.instance.subnet_filter_criteria
    values = local.settings.instance.subnet_filter_values
  }
}
