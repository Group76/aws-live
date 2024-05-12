resource "aws_docdb_subnet_group" "service" {
  name       = "catalog-sub-docdb"
  subnet_ids = ["${module.vpc.private_subnets}"]
}

resource "aws_docdb_cluster_instance" "service" {
  count              = 1
  identifier         = "catalog-docdb-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.service.id}"
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "service" {
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_docdb_subnet_group.service.name}"
  cluster_identifier      = "catalog-cluster-docdb"
  engine                  = "docdb"
  master_username         = "catalog_admin"
  master_password         = "catalog"
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.service.name}"
  vpc_security_group_ids = ["${aws_security_group.service.id}"]
}

resource "aws_docdb_cluster_parameter_group" "service" {
  family = "docdb4.0"
  name = "catalog-param"

  parameter {
    name  = "tls"
    value = "disabled"
  }

  parameter {
    name  = "collection"
    value = "product"
  }
}