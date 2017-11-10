# Setup server api security groups for prod and non-prod
resource "aws_security_group" "serverapi_sec_group_demo" {
  name        = "mx-serverapi-demo-sg"
  description = "mx serverapi restricted security group"

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

# Setup server api elb for prod and non-prod
resource "aws_elb" "serverapi_elb_demo" {
  name = "mx-demo-serverapi"

  listener {
    instance_port = "8008"

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

    target = "TCP:8008"
  }

  instances       = ["${aws_instance.serverapi_ec2_demo.*.id}"]
  security_groups = ["${aws_security_group.serverapi_sec_group_demo.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

resource "aws_lb_cookie_stickiness_policy" "serverapi_ec2_demo" {
  name                     = "elb-policy-serverapi-demo"
  load_balancer            = "${aws_elb.serverapi_elb_demo.id}"
  lb_port                  = 443
  cookie_expiration_period = 1800
}

# Setup aws instance elb for prod and non-prod
resource "aws_instance" "serverapi_ec2_demo" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.small"
  count         = 1

  vpc_security_group_ids = ["${aws_security_group.serverapi_sec_group_demo.id}"]

  tags {
    Name = "mx-serverapi-demo-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-serverapi-demo-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# Setup aws instance route53 for prod and non-prod
resource "aws_route53_record" "serverapi_route53_demo" {
  zone_id = "Z306P7HF0KMLRB"

  name = "mx-demo-serverapi.inventureaccess.com"

  type    = "CNAME"
  records = ["${aws_elb.serverapi_elb_demo.dns_name}"]
  ttl     = "300"
}

resource "aws_security_group" "serverapi_sec_group_dev" {
  name        = "mx-serverapi-dev-sg"
  description = "mx serverapi restricted security group"

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

# Setup server api elb for prod and non-prod
resource "aws_elb" "serverapi_elb_dev" {
  name = "mx-dev-serverapi"

  listener {
    instance_port = "8001"

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

    target = "TCP:8001"
  }

  instances       = ["${aws_instance.serverapi_ec2_dev.*.id}"]
  security_groups = ["${aws_security_group.serverapi_sec_group_dev.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

resource "aws_lb_cookie_stickiness_policy" "serverapi_ec2_dev" {
  name                     = "elb-policy-serverapi-dev"
  load_balancer            = "${aws_elb.serverapi_elb_dev.id}"
  lb_port                  = 443
  cookie_expiration_period = 1800
}

# Setup aws instance elb for prod and non-prod
resource "aws_instance" "serverapi_ec2_dev" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.small"
  count         = 1

  vpc_security_group_ids = ["${aws_security_group.serverapi_sec_group_dev.id}"]

  tags {
    Name = "mx-serverapi-dev-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-serverapi-dev-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# Setup aws instance route53 for prod and non-prod
resource "aws_route53_record" "serverapi_route53_dev" {
  zone_id = "Z306P7HF0KMLRB"

  name = "mx-dev-serverapi.inventureaccess.com"

  type    = "CNAME"
  records = ["${aws_elb.serverapi_elb_dev.dns_name}"]
  ttl     = "300"
}

resource "aws_security_group" "serverapi_sec_group_qa" {
  name        = "mx-serverapi-qa-sg"
  description = "mx serverapi restricted security group"

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

# Setup server api elb for prod and non-prod
resource "aws_elb" "serverapi_elb_qa" {
  name = "mx-qa-serverapi"

  listener {
    instance_port = "8003"

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

    target = "TCP:8003"
  }

  instances       = ["${aws_instance.serverapi_ec2_qa.*.id}"]
  security_groups = ["${aws_security_group.serverapi_sec_group_qa.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

resource "aws_lb_cookie_stickiness_policy" "serverapi_ec2_qa" {
  name                     = "elb-policy-serverapi-qa"
  load_balancer            = "${aws_elb.serverapi_elb_qa.id}"
  lb_port                  = 443
  cookie_expiration_period = 1800
}

# Setup aws instance elb for prod and non-prod
resource "aws_instance" "serverapi_ec2_qa" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.small"
  count         = 1

  vpc_security_group_ids = ["${aws_security_group.serverapi_sec_group_qa.id}"]

  tags {
    Name = "mx-serverapi-qa-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-serverapi-qa-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# Setup aws instance route53 for prod and non-prod
resource "aws_route53_record" "serverapi_route53_qa" {
  zone_id = "Z306P7HF0KMLRB"

  name = "mx-qa-serverapi.inventureaccess.com"

  type    = "CNAME"
  records = ["${aws_elb.serverapi_elb_qa.dns_name}"]
  ttl     = "300"
}

resource "aws_security_group" "serverapi_sec_group_qa2" {
  name        = "mx-serverapi-qa2-sg"
  description = "mx serverapi restricted security group"

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

# Setup server api elb for prod and non-prod
resource "aws_elb" "serverapi_elb_qa2" {
  name = "mx-qa2-serverapi"

  listener {
    instance_port = "8007"

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

    target = "TCP:8007"
  }

  instances       = ["${aws_instance.serverapi_ec2_qa2.*.id}"]
  security_groups = ["${aws_security_group.serverapi_sec_group_qa2.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

resource "aws_lb_cookie_stickiness_policy" "serverapi_ec2_qa2" {
  name                     = "elb-policy-serverapi-qa2"
  load_balancer            = "${aws_elb.serverapi_elb_qa2.id}"
  lb_port                  = 443
  cookie_expiration_period = 1800
}

# Setup aws instance elb for prod and non-prod
resource "aws_instance" "serverapi_ec2_qa2" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.small"
  count         = 1

  vpc_security_group_ids = ["${aws_security_group.serverapi_sec_group_qa2.id}"]

  tags {
    Name = "mx-serverapi-qa2-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-serverapi-qa2-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# Setup aws instance route53 for prod and non-prod
resource "aws_route53_record" "serverapi_route53_qa2" {
  zone_id = "Z306P7HF0KMLRB"

  name = "mx-qa2-serverapi.inventureaccess.com"

  type    = "CNAME"
  records = ["${aws_elb.serverapi_elb_qa2.dns_name}"]
  ttl     = "300"
}

resource "aws_security_group" "serverapi_sec_group_staging" {
  name        = "mx-serverapi-staging-sg"
  description = "mx serverapi restricted security group"

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

# Setup server api elb for prod and non-prod
resource "aws_elb" "serverapi_elb_staging" {
  name = "mx-staging-serverapi"

  listener {
    instance_port = "80"

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

    target = "TCP:80"
  }

  instances       = ["${aws_instance.serverapi_ec2_staging.*.id}"]
  security_groups = ["${aws_security_group.serverapi_sec_group_staging.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

resource "aws_lb_cookie_stickiness_policy" "serverapi_ec2_staging" {
  name                     = "elb-policy-serverapi-staging"
  load_balancer            = "${aws_elb.serverapi_elb_staging.id}"
  lb_port                  = 443
  cookie_expiration_period = 1800
}

# Setup aws instance elb for prod and non-prod
resource "aws_instance" "serverapi_ec2_staging" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.medium"
  count         = "2"

  vpc_security_group_ids = ["${aws_security_group.serverapi_sec_group_staging.id}"]

  tags {
    Name = "mx-serverapi-staging-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-serverapi-staging-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# Setup aws instance route53 for prod and non-prod
resource "aws_route53_record" "serverapi_route53_staging" {
  zone_id = "Z306P7HF0KMLRB"

  name = "mx-staging-serverapi.inventureaccess.com"

  type    = "CNAME"
  records = ["${aws_elb.serverapi_elb_staging.dns_name}"]
  ttl     = "300"
}

resource "aws_security_group" "serverapi_sec_group_prod" {
  name        = "mx-serverapi-prod-sg"
  description = "mx serverapi restricted security group"

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

# Setup server api elb for prod and non-prod
resource "aws_elb" "serverapi_elb_prod" {
  name = "mx-prod-serverapi"

  listener {
    instance_port = "80"

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

    target = "TCP:80"
  }

  instances       = ["${aws_instance.serverapi_ec2_prod.*.id}"]
  security_groups = ["${aws_security_group.serverapi_sec_group_prod.id}"]
  internal        = "False"
  subnets         = ["subnet-03aa7c68", "subnet-02aa7c69", "subnet-0caa7c67"]
}

resource "aws_lb_cookie_stickiness_policy" "serverapi_ec2_prod" {
  name                     = "elb-policy-serverapi-prod"
  load_balancer            = "${aws_elb.serverapi_elb_prod.id}"
  lb_port                  = 443
  cookie_expiration_period = 1800
}

# Setup aws instance elb for prod and non-prod
resource "aws_instance" "serverapi_ec2_prod" {
  ami      = "ami-718c6909"
  key_name = "Master"

  instance_type = "t2.large"
  count         = "2"

  vpc_security_group_ids = ["${aws_security_group.serverapi_sec_group_prod.id}"]

  tags {
    Name = "mx-serverapi-prod-${count.index + 1}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  subnet_id = "subnet-7779ad2c"

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname mx-serverapi-prod-${count.index + 1 }",
    ]
  }

  connection {
    user = "ubuntu"
    host = "${self.private_ip}"
  }
}

# Setup aws instance route53 for prod and non-prod
resource "aws_route53_record" "serverapi_route53_prod" {
  zone_id = "Z306P7HF0KMLRB"

  name = "mx-api.inventureaccess.com"

  type    = "CNAME"
  records = ["${aws_elb.serverapi_elb_prod.dns_name}"]
  ttl     = "300"
}
