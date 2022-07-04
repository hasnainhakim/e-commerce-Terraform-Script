#Create a ALB
resource "aws_alb" "alb" {
  name            = "terraform-example-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-security-group.id]
  #subnets         = ["${aws_subnet.main.*.id}"] you can use like this as well but below is easy way

  subnet_mapping {
    subnet_id = aws_subnet.public-subnet-1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.public-subnet-2.id

  }

  enable_deletion_protection = false

  tags = {
  
    Name = "terraform-example-alb"
  }
}

#Create Target group
#terrafrom aws target group
resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    healthy_threshold = 5
    interval          = 30
    matcher           = "200,302"
    path              = "/"
    port              = "traffic-port"
    protocol          = "HTTP"
    timeout           = 5
    unhealthy_threshold = 2

  }
}

# Create a Listener on Port 80 with Redirect Action
# terrafrom aws create listener 
resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
   target_group_arn = aws_lb_target_group.test.arn
    type             = "forward"
    redirect {
      host = "#{host}"
      path = "/#{path}"
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"

    }
  }
}

# Create a Listener on Port 443 with Forward Action
# terraform aws create listener
resource "aws_alb_listener" "alb-listener-ssl-certficate" {
  load_balancer_arn = aws_alb.alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${var.SSL-certificate}" 
  default_action {
    target_group_arn = aws_lb_target_group.test.arn
    type             = "forward"
  }
}

#Create record set in Route 53 for the load balancer

resource "aws_route53_record" "terraform" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.route53_hosted_zone_name}"
  type    = "A"
  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = true
  }
}