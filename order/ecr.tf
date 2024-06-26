resource "aws_ecr_repository" "order_ecr" {
  name = "order-ecr-repository"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}