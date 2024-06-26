resource "aws_ecr_repository" "client_ecr" {
  name = "client-ecr-repository"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}