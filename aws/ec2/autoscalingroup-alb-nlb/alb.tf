resource "aws_lb" "application" {

  load_balancer_type = "application"
  internal           = false
  subnets            = local.settings.subnet_id_public
  security_groups    = [aws_security_group.application_load_balancer.id]

  enable_cross_zone_load_balancing = true

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.source.hex)}"
    },
  )
}

resource "aws_lb_target_group" "instances" {

  for_each = { for index, record in local.settings.load_balancer_application_listening_ports : index => record }

  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = local.settings.vpc_id

  depends_on = [
    aws_lb.application
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "https" {

  load_balancer_arn = aws_lb.application.arn

  port            = "443"
  protocol        = "HTTPS"
  ssl_policy      = local.settings.load_balancer_ssl_policy
  certificate_arn = local.settings.load_balancer_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><header><title>Default response page</title></header><body><p>Nothing to see here...Keep browsing...</p></body></html>"
      status_code  = "200"
    }
  }

}


resource "aws_lb_listener_rule" "service_by_path" {

  for_each = { for index, record in local.settings.load_balancer_application_listening_ports : index => record }

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }


}

resource "aws_lb_listener" "http_redirect" {

  load_balancer_arn = aws_lb.application.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    aws_lb.application
  ]

}
