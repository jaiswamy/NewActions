provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "myvpc"
    }
}

resource "aws_subnet" "mysubnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "mysubnet"
    }
}   

resource "aws_security_group" "mysecuritygroup" {
    name = "mysecuritygroup"
    description = "My security group"
    vpc_id = aws_vpc.myvpc.id

    ingress {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  
    }
  
    ingress {
      description = "Backend API"
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Frontend"
      from_port   = 5173
      to_port     = 5173
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "actions" {
    ami = "ami-019715e0d74f695be"
    instance_type = "t3.small"
    associate_public_ip_address = true
    subnet_id = aws_subnet.mysubnet.id
    key_name = "newactions"
    vpc_security_group_ids = [aws_security_group.mysecuritygroup.id]
    tags = {
        Name = "actions"
    }
    user_data = file("test.sh")
}

resource "aws_internet_gateway" "myig" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "myig"
    }
}

resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myig.id
    }
    tags = {
        Name = "myrt"
    }
}

resource "aws_route_table_association" "myrta" {
    subnet_id = aws_subnet.mysubnet.id
    route_table_id = aws_route_table.myrt.id
}

