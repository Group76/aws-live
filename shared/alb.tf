# resource "aws_lb" "ecs_alb" {
#  name               = "ecs-alb"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = [aws_security_group.sg_shared.id]
#  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

#  tags = {
#    Name = "ecs-alb"
#  }
# }

# resource "aws_lb_listener" "ecs_alb_listener" {
#  load_balancer_arn = aws_lb.ecs_alb.arn
#  port              = 8080
#  protocol          = "HTTP"

#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.ecs_tg.arn
#  }
# }

# resource "aws_lb_target_group" "ecs_tg" {
#  name        = "ecs-target-group"
#  port        = 8080
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_vpc.main_vpc.id

#  health_check {
#    enabled = true
#    path = "/health"
#  }
# }






resource "aws_lb" "default" {
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
  load_balancer_arn = aws_lb.default.id
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.catalog.id
    type             = "forward"
  }
}