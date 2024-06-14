resource "aws_lb" "main" {
  name                             = "catalog-lb"
  load_balancer_type               = "network"
  internal = false
  subnets  = [aws_subnet.private_subnet_1.id]
}

# adds a tcp listener to the load balancer and allows ingress
resource "aws_lb_listener" "tcp" {
  load_balancer_arn = aws_lb.main.id
  port              = 8080
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "main" {
  name                 = "catalog-lb-tg"
  port                 = 8080
  protocol             = "TCP"
  vpc_id               = aws_vpc.main_vpc.id
  target_type          = "ip"
}
