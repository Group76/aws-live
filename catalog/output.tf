output "master_password" {
  value       = join("", aws_docdb_cluster.cluster[*].master_password)
  description = "Password for the master DB user"
  sensitive   = true
}
