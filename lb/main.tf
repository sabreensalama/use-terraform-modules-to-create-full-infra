
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = "application"
  count = length(var.subnet_ids)
  subnets            = var.subnet_ids[count.index]
  security_groups    = [var.sg]
}

resource "aws_lb_target_group" "target_group" {
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    port                = "traffic-port"
  }

  depends_on = [aws_lb.alb]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb[0].arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }

  depends_on = [aws_lb_target_group.target_group]
}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.target_group.arn
  count = length(var.machines_id)
  target_id        = var.machines_id[count.index]
  port             = var.port
}