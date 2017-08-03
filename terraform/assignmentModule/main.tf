provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "assignment" {
  ami                         = "${lookup(var.ami, var.region)}"
  key_name                    = "${lookup(var.key_names, var.region)}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${lookup(var.subnet_id, var.region)}"
  vpc_security_group_ids      = ["sg-14b71773","sg-94c464f3"]  #need to replace the security groups accordingly
  associate_public_ip_address = true
  monitoring                  = false

  count = 3 #creates three instances

    tags {
        Name = "${lookup(var.tagName, var.region)}-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 80
        delete_on_termination = true
    }
}
