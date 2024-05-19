resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster"
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}