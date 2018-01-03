# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "customersupport_route53_demo" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-demo-customersupport.inventureaccess.com"
  records = ["${aws_elb.customersupport_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "customersupport_route53_dev" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-dev-customersupport.inventureaccess.com"
  records = ["${aws_elb.customersupport_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "customersupport_route53_qa" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-qa-customersupport.inventureaccess.com"
  records = ["${aws_elb.customersupport_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "customersupport_route53_qa2" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-qa2-customersupport.inventureaccess.com"
  records = ["${aws_elb.customersupport_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps security groups for prod and non-prod environments
resource "aws_security_group" "customersupport_sec_group_staging" {
  name        = "mx-customersupport-staging-sg"
  description = "mx customersupport restricted security group"

  # Allow Approval Service To Be Accessed By IaC and MX Nat Gateway IPs 

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = "8001"
    to_port     = "8007"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  # Allow Public Access To datareceiver loans and payments services
  ingress {
    from_port   = "5000"
    to_port     = "9005"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# setup scala apps elb for prod and non-prod environments
resource "aws_elb" "customersupport_elb_staging" {
  name = "mx-staging-customersupport"

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

  instances       = ["${aws_instance.customersupport_ec2_staging.*.id}"]
  security_groups = ["${aws_security_group.customersupport_sec_group_staging.id}"]

  internal = "True"
  subnets  = ["subnet-7779ad2c"]
}

# setup scala apps ec2 instances for prod and non-prod environments
resource "aws_instance" "customersupport_ec2_staging" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type          = "t2.medium"
  count                  = "2"
  vpc_security_group_ids = ["${aws_security_group.customersupport_sec_group_staging.id}"]

  tags {
    Name = "mx-customersupport-staging-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-customersupport-staging-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "customersupport_route53_staging" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-staging-customersupport.inventureaccess.com"
  records = ["${aws_elb.customersupport_elb_staging.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}

# setup scala apps security groups for prod and non-prod environments
resource "aws_security_group" "customersupport_sec_group_prod" {
  name        = "mx-customersupport-prod-sg"
  description = "mx customersupport restricted security group"

  # Allow Approval Service To Be Accessed By IaC and MX Nat Gateway IPs 

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = "8001"
    to_port     = "8007"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  # Allow Public Access To datareceiver loans and payments services
  ingress {
    from_port   = "5000"
    to_port     = "9005"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# setup scala apps elb for prod and non-prod environments
resource "aws_elb" "customersupport_elb_prod" {
  name = "mx-prod-customersupport"

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

  instances       = ["${aws_instance.customersupport_ec2_prod.*.id}"]
  security_groups = ["${aws_security_group.customersupport_sec_group_prod.id}"]

  internal = "True"
  subnets  = ["subnet-7779ad2c"]
}

# setup scala apps ec2 instances for prod and non-prod environments
resource "aws_instance" "customersupport_ec2_prod" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.large"
  count         = "2"

  vpc_security_group_ids = ["${aws_security_group.customersupport_sec_group_prod.id}"]

  tags {
    Name = "mx-customersupport-prod-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-customersupport-prod-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup scala apps route53 records for prod and non-prod environments
# datareceiver and auth are public, the rest are private
resource "aws_route53_record" "customersupport_route53_prod" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-customersupport.inventureaccess.com"
  records = ["${aws_elb.customersupport_elb_prod.dns_name}"]
  type    = "CNAME"
  ttl     = "300"
}
