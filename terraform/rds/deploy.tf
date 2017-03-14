provider "aws" { }

resource "aws_security_group" "db-vpn-sg" {
  name = "db-vpn-sg"
  description = "Restricted inbound traffic"

  ingress {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "main_database" {
  identifier             = "test-instance"
  allocated_storage      = "5"
  engine                 = "MySQL"
  engine_version         = "5.6"
  instance_class         = "db.t2.medium"
  name                   = "loans"
  username               = "sam"
  password               = "test!"
  multi_az               = "True"
  storage_type           = "gp2"
  parameter_group_name   = "default.mysql5.6"
  backup_retention_period = "7"
  publicly_accessible = "True"
  vpc_security_group_ids = ["${aws_security_group.db-vpn-sg.id}"]
  db_subnet_group_name = "default"
}
