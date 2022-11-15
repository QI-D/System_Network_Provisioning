terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.55.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id             = aws_vpc.tf_vpc.id
  availability_zone  = "us-east-1a"
  cidr_block         = "10.55.10.0/24"
  tags = {
    Name = "tf_subnet_1a"
  }
}

resource "aws_internet_gateway" "tf_gw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_gw"
  }
}

resource "aws_route_table" "tf_routes" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_gw.id
  }

  tags = {
    Name = "tf_rt"
  }
}

resource "aws_route_table_association" "tf_rta" {
  subnet_id      = aws_subnet.tf_subnet.id
  route_table_id = aws_route_table.tf_routes.id
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

resource "aws_security_group" "allow_ssh_mysql" {
  name        = "allow_ssh_mysql"
  description = "Allow SSH and MySQL inbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Local MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks =  [aws_vpc.tf_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_mysql"
  }
}

resource "aws_instance" "tf_app" {
  subnet_id                   = aws_subnet.tf_subnet.id
  ami                         = "ami-08c40ec9ead489470"
  key_name                    = "qid14_keypair"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "APP"
    Service = "APP"
  }
}

resource "aws_instance" "tf_db" {
  subnet_id                   = aws_subnet.tf_subnet.id
  ami                         = "ami-08c40ec9ead489470"
  key_name                    = "qid14_keypair"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_mysql.id]

  tags = {
    Name = "DB"
    Service = "DB"
  }
}

output "app_ip_addr" {
  value = aws_instance.tf_app.public_ip
}

output "db_ip_addr" {
  value = aws_instance.tf_db.public_ip
}
