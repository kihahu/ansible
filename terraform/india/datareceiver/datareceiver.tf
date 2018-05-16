# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "datareceiver_route53_stage" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "in-dev-datareceiver.chotamotaloan.com"
  records = ["${aws_elb.datareceiver_elb_non_prod.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}
# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "datareceiver_route53_dev" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "in-dev-datareceiver.chotamotaloan.com"
  records = ["${aws_elb.datareceiver_elb_non_prod.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "datareceiver_route53_qa" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "in-qa-datareceiver.chotamotaloan.com"
  records = ["${aws_elb.datareceiver_elb_non_prod.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps security groups for prod and non-prod environments
resource "aws_security_group" "datareceiver_sec_group_non_prod" {
  name        = "in-datareceiver-non_prod-sg"
  description = "in datareceiver restricted security group"

  # Allow Approval Service To Be Accessed By IaC and MX Nat Gateway IPs 

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["172.28.0.0/16"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "9000"
    to_port     = "9005"
    protocol    = "tcp"
    cidr_blocks = ["172.28.0.0/16"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# setup scala apps elb for prod and non-prod environments
resource "aws_elb" "datareceiver_elb_non_prod" {
  name = "in-non_prod-datareceiver"

  listener {
    instance_port      = "9000"
    instance_protocol  = "http"
    lb_port            = "443"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }
  listener {
    instance_port      = "9000"
    instance_protocol  = "http"
    lb_port            = "9000"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }

  listener {
    instance_port      = "9001"
    instance_protocol  = "http"
    lb_port            = "9001"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }

  listener {
    instance_port      = "9002"
    instance_protocol  = "http"
    lb_port            = "9002"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }

  listener {
    instance_port      = "9003"
    instance_protocol  = "http"
    lb_port            = "9003"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }

  listener {
    instance_port      = "9004"
    instance_protocol  = "http"
    lb_port            = "443"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }

  listener {
    instance_port      = "9005"
    instance_protocol  = "http"
    lb_port            = "9005"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30

    target = "tcp:9001"
  }

  instances       = ["${aws_instance.datareceiver_ec2_non_prod.*.id}"]
  security_groups = ["${aws_security_group.datareceiver_sec_group_non_prod.id}"]

  internal = "False"
  subnets  = ["subnet-4dc6a900", "subnet-fdcba7b0", "subnet-02e2e66b"]
}

# setup scala apps ec2 instances for prod and non-prod environments
resource "aws_instance" "datareceiver_ec2_non_prod" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type          = "t2.medium"
  count                  = "2"
  vpc_security_group_ids = ["${aws_security_group.datareceiver_sec_group_non_prod.id}"]

  tags {
    Name = "in-datareceiver-non_prod-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname in-datareceiver-non_prod-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "datareceiver_route53_non_prod" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "in-prod-datareceiver.chotamotaloan.com"
  records = ["${aws_elb.datareceiver_elb_non_prod.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps security groups for prod and non-prod environments
resource "aws_security_group" "datareceiver_sec_group_prod" {
  name        = "in-datareceiver-prod-sg"
  description = "in datareceiver restricted security group"

  # Allow Approval Service To Be Accessed By IaC and MX Nat Gateway IPs 

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["172.28.0.0/16"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["172.28.0.0/16"]
  }
  ingress {
    from_port   = "9000"
    to_port     = "9005"
    protocol    = "tcp"
    cidr_blocks = ["172.28.0.0/16"]
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
resource "aws_elb" "datareceiver_elb_prod" {
  name = "in-prod-datareceiver"

  listener {
    instance_port      = "9000"
    instance_protocol  = "http"
    lb_port            = "443"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/chotamotaloan-2016-2018"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30

    target = "tcp:9000"
  }

  instances       = ["${aws_instance.datareceiver_ec2_prod.*.id}"]
  security_groups = ["${aws_security_group.datareceiver_sec_group_prod.id}"]

  internal = "False"
  subnets  = ["subnet-4dc6a900", "subnet-fdcba7b0", "subnet-02e2e66b"]
}

# setup scala apps ec2 instances for prod and non-prod environments
resource "aws_instance" "datareceiver_ec2_prod" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.large"
  count         = "2"

  vpc_security_group_ids = ["${aws_security_group.datareceiver_sec_group_prod.id}"]

  tags {
    Name = "in-datareceiver-prod-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname in-datareceiver-prod-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "datareceiver_route53_prod" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "in-datareceiver.chotamotaloan.com"
  records = ["${aws_elb.datareceiver_elb_prod.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}
