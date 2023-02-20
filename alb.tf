resource "aws_alb" "this" {
  name                       = local.alb.name
  internal                   = local.alb.internal
  load_balancer_type         = local.alb.load_balancer_type
  ip_address_type            = local.alb.ip_address_type
  security_groups            = local.alb.security_groups
  subnets                    = local.alb.subnets
  enable_deletion_protection = local.alb.enable_deletion_protection
  tags                       = local.alb.tags

  access_logs {
    bucket  = ""
    prefix  = ""
    enabled = false
  }

  depends_on = [
    module.vpc,
    module.ec2,
    module.sg
  ]
}

resource "aws_lb_target_group" "this" {
  name                          = local.lb_target_group.name
  port                          = local.lb_target_group.port
  protocol                      = local.lb_target_group.protocol
  protocol_version              = local.lb_target_group.protocol_version
  vpc_id                        = local.lb_target_group.vpc_id
  target_type                   = local.lb_target_group.target_type
  load_balancing_algorithm_type = local.lb_target_group.load_balancing_algorithm_type
  tags                          = local.lb_target_group.tags

  depends_on = [aws_alb.this]
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = module.ec2.id
  port             = 3000
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = local.lb_listener.load_balancer_arn
  port              = local.lb_listener.port
  protocol          = local.lb_listener.protocal
  ssl_policy        = local.lb_listener.ssl_policy
  tags              = local.lb_listener.tags
  default_action {
    type             = local.lb_listener.default_action.type
    target_group_arn = local.lb_listener.default_action.target_group_arn
  }

  depends_on = [aws_alb.this, aws_lb_target_group.this]
}

resource "aws_launch_template" "ec2" {

}