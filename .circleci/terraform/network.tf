provider "aws" {
    profile = "udacity"
    region = "sa-east-1"
}

# VARIABLES
variable "my_ip" {}
variable cidr_block_vpc {
  type = string 
  description = "vpc cidr block"
  }

variable cidr_block_subnet {
  type = list(string)
  description = "subnet cidr block"
  }

variable env {
  type        = string
  description = "environments"
}

variable avail_zone{
  type = list(string)
  description = "aws availability zone"
}

variable "instance_type" {
  type = string
  description = "ec2 ami instance type"
}


# RESOURCES
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block_vpc
    enable_dns_hostnames = true
    tags = {
        Name = "${var.env}-vpc",
        Env = var.env
        }
}


resource "aws_subnet" "subnet_pub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_block_subnet[0]
  availability_zone = var.avail_zone[0]
  tags = {
     Name = "${var.env}-subnet_pub_1"
     Env = var.env
  }
}

resource "aws_subnet" "subnet_pub_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_block_subnet[1]
  availability_zone = var.avail_zone[1]
  tags = {
     Name = "${var.env}-subnet_pub_2"
     Env = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-igw"
    Env = var.env
  }
}



resource "aws_default_route_table" "main_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    } 

  tags = {
    Name = "${var.env}-mainrt"
    Env = var.env
  }
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  description = "security group to enable ssh port 22"
  ingress  {
    cidr_blocks = [var.my_ip]
    description = "ssh port 22"
    from_port = 22
    protocol = "tcp"
    to_port = 22
  } 
  ingress  {
    cidr_blocks = ["0.0.0.0/0"]
    description = "tcp port 8080"
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "tcp port *"
    from_port = 0
    protocol = -1
    to_port = 0
  }

  tags = {
    Name = "${var.env}-sg"
    Env = var.env
  }
}


output "vpc_id" {
  value = aws_vpc.vpc.tags
}

output "subnet-pub-1" {
  value = aws_subnet.subnet_pub_1.tags["Name"]
}

output "subnet-pub-2" {
  value = aws_subnet.subnet_pub_2.tags["Name"]
}

output "igw" {
  value = aws_internet_gateway.igw.tags["Name"]
}
