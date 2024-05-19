resource "aws_ecr_repository" "client_ecr" {
  name = "client-ecr-repository"
  image_tag_mutability = "MUTABLE"
}