# setup zendesk route53 or prod and non-prod environments
resource "aws_route53_record" "zendesk_route53_demo" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-demo-services.inventureaccess.com"
  type    = "CNAME"
  records = ["${aws_elb.zendesk_elb_staging.dns_name}"]
  ttl     = "300"
}

# setup zendesk route53 or prod and non-prod environments
resource "aws_route53_record" "zendesk_route53_dev" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-dev-services.inventureaccess.com"
  type    = "CNAME"
  records = ["${aws_elb.zendesk_elb_staging.dns_name}"]
  ttl     = "300"
}

# setup zendesk route53 or prod and non-prod environments
resource "aws_route53_record" "zendesk_route53_qa" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-qa-services.inventureaccess.com"
  type    = "CNAME"
  records = ["${aws_elb.zendesk_elb_staging.dns_name}"]
  ttl     = "300"
}

# setup zendesk route53 or prod and non-prod environments
resource "aws_route53_record" "zendesk_route53_qa2" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-qa2-services.inventureaccess.com"
  type    = "CNAME"
  records = ["${aws_elb.zendesk_elb_staging.dns_name}"]
  ttl     = "300"
}

# setup zendesk security groups for prod and non-prod environments
resource "aws_security_group" "zendesk_sec_group_staging" {
  name        = "mx-zendesk-staging-sg"
  description = "mx zendesk restricted security group"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  ingress {
    from_port   = "5000"
    to_port     = "9005"
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

# setup zendesk elb or prod and non-prod environments
resource "aws_elb" "zendesk_elb_staging" {
  name = "mx-staging-zendesk"

  listener {
    instance_port      = "8000"
    instance_protocol  = "http"
    lb_port            = "8000"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "8001"
    instance_protocol  = "http"
    lb_port            = "8001"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "8003"
    instance_protocol  = "http"
    lb_port            = "8003"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "8004"
    instance_protocol  = "http"
    lb_port            = "8004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "8005"
    instance_protocol  = "http"
    lb_port            = "8005"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "4004"
    instance_protocol  = "http"
    lb_port            = "4004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "5004"
    instance_protocol  = "http"
    lb_port            = "5004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "6004"
    instance_protocol  = "http"
    lb_port            = "6004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "7004"
    instance_protocol  = "http"
    lb_port            = "7004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "8004"
    instance_protocol  = "http"
    lb_port            = "8004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "9004"
    instance_protocol  = "http"
    lb_port            = "9004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "4002"
    instance_protocol  = "http"
    lb_port            = "4002"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "5002"
    instance_protocol  = "http"
    lb_port            = "5002"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "6002"
    instance_protocol  = "http"
    lb_port            = "6002"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "7002"
    instance_protocol  = "http"
    lb_port            = "7002"
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

  # TELERIVET SERVICES ELB SPECIFIC PORTS
  listener {
    instance_port      = "8003"
    instance_protocol  = "http"
    lb_port            = "8080"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "8003"
    instance_protocol  = "http"
    lb_port            = "8443"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30

    target = "tcp:8000"
  }

  instances       = ["${aws_instance.zendesk_ec2_staging.*.id}"]
  security_groups = ["${aws_security_group.zendesk_sec_group_staging.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

# setup zendesk aws instance or prod and non-prod environments
resource "aws_instance" "zendesk_ec2_staging" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.medium"
  count         = "2"

  vpc_security_group_ids = ["${aws_security_group.zendesk_sec_group_staging.id}"]

  tags {
    Name = "mx-zendesk-staging-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-zendesk-staging-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup zendesk route53 or prod and non-prod environments
resource "aws_route53_record" "zendesk_route53_staging" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-staging-services.inventureaccess.com"
  type    = "CNAME"
  records = ["${aws_elb.zendesk_elb_staging.dns_name}"]
  ttl     = "300"
}

# setup zendesk security groups for prod and non-prod environments
resource "aws_security_group" "zendesk_sec_group_prod" {
  name        = "mx-zendesk-prod-sg"
  description = "mx zendesk restricted security group"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  ingress {
    from_port   = "5000"
    to_port     = "9005"
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

# setup zendesk elb or prod and non-prod environments
resource "aws_elb" "zendesk_elb_prod" {
  name = "mx-prod-zendesk"

  listener {
    instance_port      = "8000"
    instance_protocol  = "http"
    lb_port            = "8000"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "5004"
    instance_protocol  = "http"
    lb_port            = "5004"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  listener {
    instance_port      = "5002"
    instance_protocol  = "http"
    lb_port            = "5002"
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::347023968887:server-certificate/inventureaccess-2016-2018"
  }

  # TELERIVET SERVICES ELB SPECIFIC PORTS
  listener {
    instance_port      = "8000"
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

    target = "tcp:8000"
  }

  instances       = ["${aws_instance.zendesk_ec2_prod.*.id}"]
  security_groups = ["${aws_security_group.zendesk_sec_group_prod.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

# setup zendesk aws instance or prod and non-prod environments
resource "aws_instance" "zendesk_ec2_prod" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.large"
  count         = "2"

  vpc_security_group_ids = ["${aws_security_group.zendesk_sec_group_prod.id}"]

  tags {
    Name = "mx-zendesk-prod-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-zendesk-prod-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# setup zendesk route53 or prod and non-prod environments
resource "aws_route53_record" "zendesk_route53_prod" {
  zone_id = "Z306P7HF0KMLRB"

  name    = "mx-services.inventureaccess.com"
  type    = "CNAME"
  records = ["${aws_elb.zendesk_elb_prod.dns_name}"]
  ttl     = "300"
}
