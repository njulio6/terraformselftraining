#############################################################################
#   EC2 INSTANCE
#############################################################################
resource "aws_instance" "juliusnfor" {
  ami           = "ami-05fa00d4c63e32376"
  key_name = "jnfor"
  instance_type = "t2.micro"

  tags = {
    Name = "Baby_terraformer"
  }
}

#############################################################################
#   EXTRA EBS VOLUME
#############################################################################
resource "aws_ebs_volume" "julius_volume" {
  availability_zone = "us-east-1a"
  size              = 16
  type = "gp2"

  tags = {
    Name = "Baby_terraformer"
  }
}

#############################################################################
#  ELASTIC_IP CREATION AND ATTACHMENT
#############################################################################
resource "aws_eip" "julius_eip" {
  instance = aws_instance.juliusnfor.id
  vpc      = true
}

#############################################################################
# OUTPUT_OF_EIP
#############################################################################
output "eip" {
    value = aws_eip.julius_eip
}

#############################################################################
#  SECURITY GROUP
#############################################################################
resource "aws_vpc" "julius" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "allow_tcp" {
  name        = "allow_tcp"
  description = "Allow tcp inbound traffic"
  vpc_id      = aws_vpc.julius.id

ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.julius.ipv6_cidr_block]
  }

ingress {
    description      = "tcp"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.julius.ipv6_cidr_block]
  }

ingress {
    description      = "tcp"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.julius.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tcp"
  }
}

# variable "key_name" {
#   description = " credentials keys to connect to ec2 instance"
#   default = "jnfor"
# }

# variable "ami_id" {
#   description = "AMI ID for julius Ec2 instance"
#   default = "ami-05fa00d4c63e32376"
# }

# variable "aws_region" {
#   description = "AWS region in which I want to deploy resources."
#   default = "us-east-1"
# }