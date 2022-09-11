provider "aws" {
  version = "~> 4.0"
  region = "us-east-1"
}

resource "aws_vpc" "imp" {
  cidr_block = var.my_aws_vpc

tags = {
    name = var.vpc_tags
    }

}

resource "aws_subnet" "imp0rtant" {
    vpc_id = aws_vpc.imp.id
    cidr_block = var.my_aws_subnet
    availability_zone = var.region
   

    tags = {
        name = var.subnet_tags
    }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.imp.id
  cidr_block = var.private_subnet
  availability_zone = var.region
}

resource "aws_internet_gateway" "mygateway" {
  vpc_id = aws_vpc.imp.id

  tags = {
    name = "gateway"
  }
}

resource "aws_route_table" "my_route" {
  vpc_id = aws_vpc.imp.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygateway.id
  }
  tags = {
    name = "my_route_table"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_internet_gateway.mygateway.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygateway.id
  }
  
  tags = {
    name = "my_private_route_table"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id = aws_subnet.imp0rtant.id
  route_table_id = aws_route_table.my_route.id
}

resource "aws_route_table_association" "private_association" {
  subnet_id = aws_subnet.private.id
route_table_id = aws_route_table.private_route.id

}
  resource "aws_security_group" "security" {
    name = "allow ssh and icmp"
    vpc_id = aws_vpc.imp.id

 ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  name = "my_security_group"
}
  }

  resource "aws_instance" "master_ansible"{
    ami = var.my_ami
    availability_zone = var.region
    instance_type = var.my_instance_type
subnet_id = aws_subnet.imp0rtant.id
private_ip = "10.0.1.10"
vpc_security_group_ids = [aws_security_group.security.id]
key_name = "khubaibkeypair"

tags = {
  name = "master_ansible"
} 
  }
  

resource "aws_instance" "ansible_slave" {
  #create 3 identical aws ec2 instances
  count = 3
  #All 3 instances will have the same ami and instance type
  ami = var.my_ami
  instance_type = var.my_instance_type
  availability_zone = var.region
  subnet_id = aws_subnet.private.id
  private_ip = element(var.my_private_ip_slaves, count.index)
  vpc_security_group_ids = ["aws_security_group.security.security.id"]
  key_name = "ansible-keypair"


tags = {
  name = "ansible_slave-${count.index+1}"
}
}

#addin