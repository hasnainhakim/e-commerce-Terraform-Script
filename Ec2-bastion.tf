#create EC2 in bastion host
resource "aws_instance" "Ec2"{
    ami                    = "ami-04c921614424b07cd"
    instance_type               = "${var.instance_type}"
    key_name                    = "${var.generated_key_name}"
    subnet_id           = aws_subnet.public-subnet-1.id
    associate_public_ip_address = "True"
    vpc_security_group_ids = [aws_security_group.ssh-security-group.id]

    tags {

  Name = "Jump Off server"

 }
}