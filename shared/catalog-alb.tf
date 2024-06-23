resource "aws_lb" "catalog" {
  name            = "catalog-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "catalog" {
  name        = "ecs-catalog-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

   health_check {
   enabled = true
   path = "/health"
 }
}

resource "aws_lb_listener" "catalog" {
  load_balancer_arn = aws_lb.catalog.id
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.catalog.id
    type             = "forward"
  }
}