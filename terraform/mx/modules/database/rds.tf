# Setup rds security group
resource "aws_security_group" "db-vpn-sg" {
  name        = "mx-db-vpn-sg"
  description = "Restricted inbound traffic"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

# Create maindb instance
resource "aws_db_instance" "main_database" {
  identifier              = "prod-mx-maindb"
  allocated_storage       = "1500"
  engine                  = "MySQL"
  engine_version          = "5.6"
  instance_class          = "db.m4.large"
  username                = "insightuser"
  password                = "QsPqxsbU6MZM"
  multi_az                = "False"
  storage_type            = "gp2"
  parameter_group_name    = "default.mysql5.6"
  backup_retention_period = "7"
  publicly_accessible     = "False"
  vpc_security_group_ids  = ["${aws_security_group.db-vpn-sg.id}"]
  db_subnet_group_name    = "default"
}

# Create datareceiver instance
resource "aws_db_instance" "datareceiver_main_database" {
  identifier              = "prod-mx-datareceiver-maindb"
  allocated_storage       = "1500"
  engine                  = "MySQL"
  engine_version          = "5.6"
  instance_class          = "db.m4.large"
  username                = "insightuser"
  password                = "vk8s6BPswsTE"
  multi_az                = "False"
  storage_type            = "gp2"
  parameter_group_name    = "default.mysql5.6"
  backup_retention_period = "7"
  publicly_accessible     = "False"
  vpc_security_group_ids  = ["${aws_security_group.db-vpn-sg.id}"]
  db_subnet_group_name    = "default"
}

# Create dev rds instance
resource "aws_db_instance" "internal_testing_database" {
  identifier              = "dev-mx"
  allocated_storage       = "500"
  engine                  = "MySQL"
  engine_version          = "5.6"
  instance_class          = "db.m4.xlarge"
  username                = "insightuser"
  password                = "jANIAjn7ZwKK2"
  multi_az                = "False"
  storage_type            = "gp2"
  parameter_group_name    = "internal-testing-connections"
  backup_retention_period = "7"
  publicly_accessible     = "False"
  vpc_security_group_ids  = ["${aws_security_group.db-vpn-sg.id}"]
  db_subnet_group_name    = "default"
}
