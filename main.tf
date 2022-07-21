#------------------------------------------------------------------------------------------------------
# Data Sources: The data sources that are used to fetch already existing resources in AWS.
#------------------------------------------------------------------------------------------------------

# Data source to get the access to the effective Account ID, User ID, and ARN in which Terraform is authorized.


# data "aws_iam_role" "example_role" {
#   name = var.role_name
# }


# data "template_file" "userdata" {
#   template = file("resources/userdata.tpl")
#   vars = {
#     fs_id = var.fs_id
#   }
# }


resource "aws_instance" "example_ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
#   user_data_base64 = "${base64encode(data.template_file.userdata.rendered)}"
  vpc_security_group_ids = (var.security_group)
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.key_pair.id
  associate_public_ip_address = false
  root_block_device {
    volume_size = var.volume_size
  }
#   iam_instance_profile = data.aws_iam_role.example_role.name
   tags = {
      Name = var.instance_name
      component = var.component
    }
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh

  provisioner "local-exec" { 
    # Create a ".pem" file to your current location!!
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ./privatekey.pem"
  }
  tags = {
      Name = var.key_name
      component = var.component
    }
}


data "aws_route53_zone" "route53_zone_existing" {
  name         = var.hosted_Zone_Name
  private_zone = true
}

# record set for ec2 created in existing domain
resource "aws_route53_record" "example_ec2_record_set" {

   alias {
    evaluate_target_health = false
    name = aws_lb.loadbalaner.dns_name
    zone_id = aws_lb.loadbalaner.zone_id
  }

  zone_id = data.aws_route53_zone.route53_zone_existing.zone_id
  name    = var.hosted_record-set
  type    = "A"
}

resource "aws_lb" "loadbalaner" {
  ip_address_type = "ipv4"
  internal = true
  name = var.lb_name
  security_groups = [var.securitygroup80, var.securitygroup443]
  subnets = [var.subnet_id, var.subnet_id2]
  enable_deletion_protection = false
  idle_timeout = 600
  tags = {
    Name      = "${var.lb_name}-alb"
    component = var.component
  }
}

resource "aws_alb_target_group" "ip_target_group" {
  depends_on = [aws_lb.loadbalaner]
  name = var.tg_name
    health_check {
    enabled = true
    interval = 120
    path = "/"
    protocol = "HTTP"
    timeout = 20
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200"
  }
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
  deregistration_delay = 30
  vpc_id = var.vpc
  tags = {
    Name      = "${var.lb_name}-tg"
    component = var.component
  }
}

resource "aws_lb_target_group_attachment" "lb_attachment" {
  
  target_group_arn = aws_alb_target_group.ip_target_group.arn
  target_id        = aws_instance.example_ec2.private_ip
  port             = 80
  }

resource "aws_lb_listener" "tg_lb_listener" {
  depends_on = [aws_alb_target_group.ip_target_group]
  load_balancer_arn = aws_lb.loadbalaner.arn
  port = 443
  protocol = "HTTPS"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ip_target_group.arn
  }
  certificate_arn = var.certificate_arn
}

resource "aws_lb_listener" "alb_listner" {
  depends_on = [aws_lb.loadbalaner]
  load_balancer_arn = aws_lb.loadbalaner.arn
  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      port = "443"
      protocol = "HTTPS"
    }
  }
  port = 80
  protocol = "HTTP"
}
