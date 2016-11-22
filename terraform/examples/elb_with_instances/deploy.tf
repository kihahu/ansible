provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_elb" "dev" {
  name = "${var.elb_name}"

  availability_zones = ["${aws_instance.dev.*.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances = ["${aws_instance.dev.*.id}"]
}

resource "aws_instance" "dev" {
  ami           = "${lookup(var.ami, var.region)}"
  key_name      = "${lookup(var.key_names, var.region)}"
  instance_type = "${var.instance_type}"

  count = 2

    tags {
        Name = "${var.tagName}-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 100
        delete_on_termination = true
    }
}
