provider "random" {}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "orders"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "orders"
  password             = "$Xf5$n6y>~A?v%W"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}<>:?"
}

output "rds_password" {
  value     = random_password.password.result
  sensitive = true
}