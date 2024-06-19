# Internet Gateway
resource "aws_internet_gateway" "net_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}