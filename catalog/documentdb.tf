resource "aws_docdb_subnet_group" "sg_docdb" {
  name       = "catalog-sub-docdb"
  subnet_ids = "${module.vpc.private_subnets}"
}

resource "aws_docdb_cluster_instance" "cluster_instance" {
  count              = 1
  identifier         = "catalog-docdb-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.cluster.id}"
  instance_class     = "db.t3.medium"
}

resource "random_password" "password" {
  count   = 1
  length  = 16
  special = false
}

resource "aws_docdb_cluster" "cluster" {
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_docdb_subnet_group.sg_docdb.name}"
  cluster_identifier      = "catalog-cluster-docdb"
  engine                  = "docdb"
  master_username         = "catalog_admin"
  master_password         = random_password.password[0].result
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.param.name}"
  vpc_security_group_ids = ["${aws_security_group.sg_catalog.id}"]
}

resource "aws_docdb_cluster_parameter_group" "param" {
  family = "docdb5.0"
  name = "catalog-param"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}