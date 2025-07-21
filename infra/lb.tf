resource "aws_lb" "nlb" {
  name               = "ecs-lb"
  internal           = var.lb_internal
  load_balancer_type = var.load_balancer_type
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "my-nlb-tg"
  port        = 8080
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = module.vpc.vpc_id

  health_check {
    protocol            = var.protocol
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
  }
  tags = var.tags

}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.lb_listener_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
  tags = var.tags
}