resource "random_id" "suffix" {
  keepers = {
    description = local.settings.tags_common.purpose
  }

  byte_length = 2
}
