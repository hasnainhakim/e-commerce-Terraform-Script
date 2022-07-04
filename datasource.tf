data "aws_route53_zone" "zone" {
  name = "${var.route53_hosted_zone_name}"
}

data "template_file" "provision" {
  template = "${file("${path.module}/provision.sh")}"
}

