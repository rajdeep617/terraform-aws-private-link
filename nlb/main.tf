resource "aws_lb" "internal" {
  name                             = "${var.name_tag}-nlb"
  internal                         = var.internal_nlb
  load_balancer_type               = "network"
  subnets                          = var.subnet_ids
  idle_timeout                     = var.idle_timeout
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  tags = {
    Name = "${var.name_tag}-nlb"
  }
}

resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal.arn
  }
}

resource "aws_lb_target_group" "internal" {
  name        = "${var.name_tag}-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  tags = {
    Name = var.name_tag
  }
}

resource "aws_lb_target_group_attachment" "internal" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.internal.arn
  target_id        = var.instance_ids[count.index]
  port             = var.nlb_listener_port
}