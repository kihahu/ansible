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

  egress {
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev" {
  ami           = "ami-8bcc54e7"
  key_name      = "master_sao_paulo"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sec_group.id}"]

  count = 2

    tags {
        Name = "demo.${count-index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}
