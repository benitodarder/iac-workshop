## Environment Common ##
variable "account_id" {
  type    = string
  default = "940718188469"
}
variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "tags" {
  type    = map(string)
  default = {}
}

## Environment ##
variable "ami_name_prefix" {
  type = string
}
variable "cloud_init_path" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t3a.small"
}
variable "source_ami_name_pattern" {
  type = string
}
variable "source_ami_owners" {
  type    = list(string)
  default = ["137112412989"]
}
variable "subnet_id" {
  type = string
}
variable "vpc_id" {
  type = string
}
