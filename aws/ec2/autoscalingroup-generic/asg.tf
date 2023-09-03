locals {
  target_group_arns = flatten([[for group in aws_lb_target_group.nlb : [group.arn]], [for group in aws_lb_target_group.alb : [group.arn]]])
}

data "template_file" "cloud_init" {
  template = file(local.settings.cloud_init_file_path)

  vars = {
    region = local.settings.tags_common.region
  }
}

module "ec2-instance-asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name            = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
  use_name_prefix = false

  min_size                  = local.settings.asg_min_size
  max_size                  = local.settings.asg_max_size
  desired_capacity          = local.settings.asg_desired_capacity
  wait_for_capacity_timeout = local.settings.asg_wait_for_capacity_timeout
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.aws_subnets.filter.ids

  user_data = base64encode(data.template_file.cloud_init.rendered)

  initial_lifecycle_hooks = [
    {
      name                 = "StartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 30
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    },
    {
      name                 = "TerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 30
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
      instance_warmup        = 30
    }
    triggers = ["tag"]
  }

  # Launch configuration
  launch_template_name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"


  image_id          = random_id.detail.keepers.ami_id
  instance_type     = local.settings.instance_type
  ebs_optimized     = true
  enable_monitoring = true

  iam_instance_profile_name = module.iam_role_ec2.iam_role_name
  security_groups           = [aws_security_group.instance.id]

  target_group_arns = local.target_group_arns

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = local.settings.ebs_volume_size
        volume_type           = local.settings.ebs_volume_type
      }
    }
  ]


  tags = merge(
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    }
  )

  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  depends_on = [
    aws_lb_target_group.nlb,
    aws_lb_target_group.alb
  ]
}
