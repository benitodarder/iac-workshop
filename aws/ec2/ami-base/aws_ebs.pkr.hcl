source "amazon-ebs" "ami" {
  ami_name      = "${var.ami_name_prefix}-{{isotime `2006-01-02-T030405`}}"
  instance_type = var.instance_type
  region        = var.region
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id

  user_data = base64encode(
    templatefile(
      var.cloud_init_path,
      {
        region = var.region
      }
    )
  )

  source_ami_filter {
    filters = {
      name                = var.source_ami_name_pattern
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners      = var.source_ami_owners
  }

  ssh_username = "ec2-user"

  tags = merge(
    var.tags,
    {
      "Name"          = "${var.ami_name_prefix}-{{isotime `2006-01-02-T030405`}}",
      "Base_AMI_ID"   = "{{ .SourceAMI }}",
      "Base_AMI_Name" = "{{ .SourceAMIName }}"
    }
  )

}

build {
  sources = [
    "source.amazon-ebs.ami"
  ]

  provisioner "shell" {
    inline = [
      #"sudo tail -f /var/log/cloud-init-output.log",
      "sudo /usr/bin/cloud-init status --wait",
    ]

    execute_command = "{{ .Vars }} bash {{ .Path }}"
  }

}
