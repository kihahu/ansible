provider "aws" { }

resource "aws_vpc" "main_vpc" {
   cidr_block = "172.32.0.0/16"
}

resource "aws_security_group" "sec_group" {
   name = "sec_group"
   description = "Restricted security group"

   ingress {
      from_port = "443"
      to_port = "443"
      protocol = "tcp"
      cidr_blocks = ["172.28.0.0/16","172.29.0.0/16","172.30.0.0/16","172.31.0.0/16","172.32.0.0/16"]
   }

   ingress {
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      from_port = "5000"
      to_port = "5005"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      from_port = "9005"
      to_port = "9005"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      from_port = "443"
      to_port = "443"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
      from_port = "9000"
      to_port = "9005"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
  egress {
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

/* API ELB AND INSTANCES */
resource "aws_elb" "api_elb" {
  name = "api-elb-ldl"

  availability_zones = ["${aws_instance.api_ec2.*.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  instances = ["${aws_instance.api_ec2.*.id}"]
}

resource "aws_instance" "api_ec2" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 2

    tags {
        Name = "api-prd-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}

resource "aws_route53_record" "api_prd" {
  zone_id = "Z306P7HF0KMLRB"
  name = "br-apiv2.inventureaccess.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.api_elb.dns_name}"]
}

/* DR ELB AND INSTANCES */
resource "aws_elb" "dr_elb" {
  name = "dr-elb-ldl"

  availability_zones = ["${aws_instance.dr_ec2.*.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  instances = ["${aws_instance.dr_ec2.*.id}"]
}

resource "aws_instance" "dr_ec2" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 2

    tags {
        Name = "data-receiver-prd-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}

resource "aws_route53_record" "dr_prd" {
  zone_id = "Z306P7HF0KMLRB"
  name = "br-drv2.inventureaccess.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.dr_elb.dns_name}"]
}

/* DATA LOGGING ELB AND INSTANCES */
resource "aws_elb" "data_logging_elb" {
  name = "data-logging-elb-ldl"

  availability_zones = ["${aws_instance.data_logging_ec2.*.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  instances = ["${aws_instance.data_logging_ec2.*.id}"]
}

resource "aws_instance" "data_logging_ec2" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 2

    tags {
        Name = "data-logging-prd-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}

resource "aws_route53_record" "data_logging_elb_prd" {
  zone_id = "Z306P7HF0KMLRB"
  name = "br-loggingv2.inventureaccess.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.data_logging_elb.dns_name}"]
}


/* DATA ELB AND INSTANCES */
resource "aws_elb" "data_elb" {
  name = "data-elb-ldl"

  availability_zones = ["${aws_instance.data_ec2.*.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  instances = ["${aws_instance.data_ec2.*.id}"]
}

resource "aws_instance" "data_ec2" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 2

    tags {
        Name = "data-prd-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}

resource "aws_route53_record" "data_prd" {
  zone_id = "Z306P7HF0KMLRB"
  name = "br-scoringv2.inventureaccess.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.data_elb.dns_name}"]
}


/* DATA LOGGING AND DATA DEV/QA/STAGING SINGLE INSTANCES */
resource "aws_instance" "data_logging_dev_ec2" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 6

    tags {
        Name = "data-team-dev-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}

/* PROFILING PRODUCTION DEV/QA/STAGING SINGLE INSTANCES */
resource "aws_instance" "profiling_dev_ec2" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 2

    tags {
        Name = "profiling-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}

/* DATA REPOSITORY PROFILING PRODUCTION DEV/QA/STAGING SINGLE INSTANCES */
resource "aws_instance" "data_repository_dev_ec2" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 2

    tags {
        Name = "data-repository-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}

/* MAIN RDS INSTANCE */

resource "aws_security_group" "db-vpn-sg" {
  name = "db-vpn-sg"
  description = "Restricted inbound traffic"

  ingress {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["172.28.0.0/16","172.29.0.0/16","172.30.0.0/16","172.31.0.0/16","172.32.0.0/16"]
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
  username               = "insightuser"
  password               = "test"
  multi_az               = "True"
  storage_type           = "gp2"
  parameter_group_name   = "default.mysql5.6"
  backup_retention_period = "7"
  publicly_accessible = "True"
  vpc_security_group_ids = ["${aws_security_group.db-vpn-sg.id}"]
  db_subnet_group_name = "default"
}
