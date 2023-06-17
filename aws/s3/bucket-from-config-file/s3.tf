data "template_file" "s3_policy_only_ssl_transport" {
  template = file("${path.module}/assets/s3_policy_only_ssl_transport.json")

  vars = {
    bucket_name = "${var.service_name}-${var.service_resource}-${local.key_suffix_hyphen}"
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2"

  bucket = "${var.service_name}-${var.service_resource}-${local.key_suffix_hyphen}"

  versioning = {
    enabled = true
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  attach_policy = true

  policy = data.template_file.s3_policy_only_ssl_transport.rendered

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  tags = var.tags

}
