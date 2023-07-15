data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_elb" "network" {

  availability_zones = data.aws_availability_zones.available.names


  dynamic "listener" {
    for_each = { for index, record in local.settings.listening_ports_protocols : index => record }
    content {
      instance_port     = listener.value.instance_port
      instance_protocol = listener.value.protocol
      lb_port           = listener.value.lb_port
      lb_protocol       = listener.value.protocol
    }
  }


  health_check {
    healthy_threshold   = local.settings.healthcheck_healthy_threshold
    unhealthy_threshold = local.settings.healthcheck_unhealthy_threshold
    timeout             = local.settings.healthcheck_timeout
    target              = local.settings.healthcheck_target
    interval            = local.settings.healthcheck_interval
  }

  instances                   = [module.ec2-instance-base.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  security_groups             = [aws_security_group.elb.id]

  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    },
  )
}
