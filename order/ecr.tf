resource "aws_ecr_repository" "order_ecr" {
  name = "order-ecr-repository"
  image_tag_mutability = "MUTABLE"
}