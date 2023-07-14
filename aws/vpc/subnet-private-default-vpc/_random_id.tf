resource "random_id" "detail" {
  keepers = {
    vpc_id = local.settings.vpc_id
  }

  byte_length = 2
}
