resource "random_id" "detail" {
  keepers = {
    cidr_block = local.settings.cidr_block
  }

  byte_length = 2
}
