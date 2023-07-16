resource "random_id" "source" {
  keepers = {
    ami_id = data.aws_ami.ec2_ami_base.id
  }

  byte_length = 2
}
