module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-shared"
  cidr = "10.0.0.0/15"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets  = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]

  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = false
}

resource "aws_security_group" "sg_shared" {
  name        = "shared"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}