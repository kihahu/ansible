# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "payments-service_route53_demo" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-demo-payments.inventureaccess.com"
  records = ["${aws_elb.payments-service_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "payments-service_route53_dev" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-dev-payments.inventureaccess.com"
  records = ["${aws_elb.payments-service_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "payments-service_route53_qa" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-qa-payments.inventureaccess.com"
  records = ["${aws_elb.payments-service_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "payments-service_route53_qa2" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-qa2-payments.inventureaccess.com"
  records = ["${aws_elb.payments-service_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps security groups for prod and non-prod environments
resource "aws_security_group" "payments-service_sec_group_staging" {
  name        = "mx-payments-service-staging-sg"
  description = "mx payments-service restricted security group"

  # Allow Approval Service To Be Accessed By IaC and MX Nat Gateway IPs 

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/16","10.0.0.0/8"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# setup scala apps elb for prod and non-prod environments
resource "aws_elb" "payments-service_elb_staging" {
  name = "mx-staging-payments-service"

  listener {
    instance_port      = "9000"
    instance_protocol  = "http"
    lb_port            = "9000"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "9001"
    instance_protocol  = "http"
    lb_port            = "9001"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "9002"
    instance_protocol  = "http"
    lb_port            = "9002"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "9003"
    instance_protocol  = "http"
    lb_port            = "9003"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "9004"
    instance_protocol  = "http"
    lb_port            = "443"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "9005"
    instance_protocol  = "http"
    lb_port            = "9005"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30

    target = "tcp:9001"
  }

  instances       = ["${aws_instance.payments-service_ec2_staging.*.id}"]
  security_groups = ["${aws_security_group.payments-service_sec_group_staging.id}"]

  internal = "False"
  subnets  = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

# setup scala apps ec2 instances for prod and non-prod environments
resource "aws_instance" "payments-service_ec2_staging" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type          = "t2.medium"
  count                  = "2"
  vpc_security_group_ids = ["${aws_security_group.payments-service_sec_group_staging.id}"]

  tags {
    Name = "mx-payments-service-staging-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-payments-service-staging-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "payments-service_route53_staging" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-staging-payments.inventureaccess.com"
  records = ["${aws_elb.payments-service_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps security groups for prod and non-prod environments
resource "aws_security_group" "payments-service_sec_group_prod" {
  name        = "mx-payments-service-prod-sg"
  description = "mx payments-service restricted security group"

  # Allow Approval Service To Be Accessed By IaC and MX Nat Gateway IPs 
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/16","10.0.0.0/8"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# setup scala apps elb for prod and non-prod environments
resource "aws_elb" "payments-service_elb_prod" {
  name = "mx-prod-payments-service"

  listener {
    instance_port      = "9000"
    instance_protocol  = "http"
    lb_port            = "443"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30

    target = "tcp:9000"
  }

  instances       = ["${aws_instance.payments-service_ec2_prod.*.id}"]
  security_groups = ["${aws_security_group.payments-service_sec_group_prod.id}"]

  internal = "False"
  subnets  = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

# setup scala apps ec2 instances for prod and non-prod environments
resource "aws_instance" "payments-service_ec2_prod" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.large"
  count         = "2"

  vpc_security_group_ids = ["${aws_security_group.payments-service_sec_group_prod.id}"]

  tags {
    Name = "mx-payments-service-prod-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-payments-service-prod-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "payments-service_route53_prod" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-payments.inventureaccess.com"
  records = ["${aws_elb.payments-service_elb_prod.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}
