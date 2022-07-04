resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh

   }


#Create a new EC2 launch configuration
resource "aws_launch_configuration" "launch_config" {
  name_prefix                 = "terraform-example-web-instance"
  image_id                    = "ami-04c921614424b07cd"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.generated_key_name}"
  security_groups             = ["${aws_security_group.webserver-security-group.id}"]
  associate_public_ip_address = true
  user_data                   = "${data.template_file.provision.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.launch_config.id}"
  min_size             = "2"
  max_size             = "4"
  target_group_arns    = ["${aws_lb_target_group.test.arn}"] 
  vpc_zone_identifier  =  [aws_subnet.private-subnet-2.id,aws_subnet.private-subnet-1.id]

  tag {
    key                 = "Name"
    value               = "terraform-example-autoscaling-group"
    propagate_at_launch = true
  }
}