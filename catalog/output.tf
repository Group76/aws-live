
output "master_password" {
      value = nonsensitive(join("", aws_docdb_cluster.cluster[*].master_password))
    }