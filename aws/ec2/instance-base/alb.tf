resource "aws_lb" "network" {
  name               = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}"
  load_balancer_type = "network"
  internal           = false
  subnets            = local.settings.subnet_id_public

  enable_cross_zone_load_balancing = true

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.instance_name}"
    },
  )
}

resource "aws_lb_target_group" "ssh" {
  port     = 22
  protocol = "TCP"
  vpc_id   = local.settings.vpc_id

  depends_on = [
    aws_lb.network
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "ssh" {

  load_balancer_arn = aws_lb.network.arn

  protocol = "TCP"
  port     = 22

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssh.arn
  }
}

resource "aws_lb_target_group_attachment" "ssh" {
  target_group_arn = aws_lb_target_group.ssh.arn
  target_id        = module.ec2-instance-base.id
  port             = 22
}
