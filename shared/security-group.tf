# Security Group for EC2 Instance
resource "aws_security_group" "sg_shared" {
  name        = "sg_shared"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
}