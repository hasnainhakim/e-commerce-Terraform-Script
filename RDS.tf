# Create Database Subnet Group
# terraform aws db subnet group
resource "aws_db_subnet_group" "database-subnet-group" {
  name         = "database subnets"
  subnet_ids   = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description  = "Subnets for Database Instance"

  tags   = {
    Name = "Database Subnets"
  }
}

resource "aws_db_instance" "default" {
 #vpc_id      = aws_vpc.vpc.id
 availability_zone       = "eu-central-1b"   
 allocated_storage = 50
 skip_final_snapshot     = true
 identifier = "sampleinstance"
 storage_type = "gp2"
 engine = "mysql"
 engine_version = "5.7"
 instance_class = "db.t2.micro"
 name = "sample"
 username = "dbadmin"
 password = "DBAdmin52"
 parameter_group_name = "default.mysql5.7"
 final_snapshot_identifier = "Ignore"
 vpc_security_group_ids  = [aws_security_group.database-security-group.id]
 db_subnet_group_name    = aws_db_subnet_group.database-subnet-group.name
 
 
}