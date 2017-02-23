# Datadrivers' Terraform demo with AWS
#

# Configure the aws provider with your credentials
#
# If you don't use the aws-cli, please create a credential file and add all
# login information. After that add the path of the file to the config parameter
# shared_credentials_file and remove the beginning '#' to activate it.
# Alternative use the config parameters access_key and secret_key with your credentials.
#

provider "aws" {
  region     = "us-west-2"
  #access_key = "INSERT AWS ACCESS KEY HERE"
  #secret_key = "INSERT AWS SECRET KEY HERE"
  #shared_credentials_file = "INSERT PATH TO THE FILE HERE"
}

# Configure the ssh keypair
#
# Point to an existing one in AWS or local on your computer
# If you are using a local existing SSH key, please add the file content of the SSH Public Key as one line to the config parameter public_key
#

resource "aws_key_pair" "example_demo_keypair" {
  key_name = "example-demo-keypair"
  #public_key = "FILL ME WITH CONTENT"
}

# Create and configure an AWS security group with simple firewall policies to allow incoming SSH (port 22) and HTTP traffic

resource "aws_security_group" "default" {
  name        = "terraform_example_sg"
  description = "Used in the terraform demo"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Configure the AWS ec2 webserver instance (
#
# Default: Ubuntu Server 16.06 LTS on AWS region us-west-2
#
# Note: The userdata.sh script installs the webserver software nginx on the system and starts the service
#       
#       - To connect via ssh, type in your shell ssh -l ubuntu <public dns>
#       - To test the webserver open your browser and type http://<public dns>
#
#       Example: shell -> ssh -l ubuntu ec2-xxxxxxxx.us-west-2.compute.amazonaws.com
#                browser -> http://ec2-xxxxxxxx.us-west-2.compute.amazonaws.com

resource "aws_instance" "example" {
  ami = "ami-7c803d1c" #Ubuntu Server 16.04 LTS
  instance_type = "t2.micro"
  tags {
        Name = "Terraform_demo_from_Datadrivers"
  }
  user_data = "${file("userdata.sh")}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "example-demo-keypair"
}

# Output
#

output "public ip" {
  value = "${aws_instance.example.public_ip}"
}

output "public dns" {
  value = "${aws_instance.example.public_dns}"
}

