data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {

  map_public_ip_on_launch = false
  vpc_id                  = aws_default_vpc.this.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(local.settings.cidr_block, local.settings.cidrsubnet_newbits, 1)

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    }
  )
}
