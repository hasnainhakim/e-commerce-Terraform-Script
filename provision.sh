#!/bin/bash
sudo su
yum update -y
yum install httpd -y
chkconfig httpd on
cd /var/www/html
aws s3 sync s3://coffee-shop-demo-4 /var/www/html
service httpd start