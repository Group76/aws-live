resource "aws_instance" "mysql_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_shared.id]
  subnet_id     = aws_subnet.public[0].id
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y docker
              service docker start
              usermod -a -G docker ec2-user
              curl -fsSL https://get.docker.com -o get-docker.sh
              sh get-docker.sh
              systemctl start docker
              systemctl enable docker
              docker run -d --name mysql-order -e MYSQL_ROOT_PASSWORD=$Xf5$n6y>~A?v%W -e MYSQL_DATABASE=order -e MYSQL_USER=orders -e MYSQL_PASSWORD=$Xf5$n6y>~A?v%W -p 3306:3306 mysql:latest

              EOF

  tags = {
    Name = "Order MySql-Server"
  }
}