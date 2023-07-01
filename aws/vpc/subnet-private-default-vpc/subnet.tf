data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "main_private" {

  map_public_ip_on_launch = false
  vpc_id                  = local.settings.vpc_id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(local.settings.cidr_block, local.settings.cidrsubnet_newbits, 1)

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}"
    }
  )
}
