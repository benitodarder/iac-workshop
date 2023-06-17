locals {
  key_suffix            = "${var.environment}${var.purpose}"
  key_suffix_hyphen     = "${var.environment}-${var.purpose}"
  key_suffix_underscore = "${var.environment}_${var.purpose}"
}