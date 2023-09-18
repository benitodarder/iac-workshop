resource "aws_subnet" "this" {

  for_each = { for index, record in local.settings.subnets : index => record }

  map_public_ip_on_launch = false
  vpc_id                  = aws_default_vpc.this.id
  availability_zone       = each.value.availability_zone
  cidr_block              = cidrsubnet(local.settings.cidr_block, each.value.newbits, 1 + each.key)

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    }
  )
}

