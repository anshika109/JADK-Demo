provider "aws" {
    region = "ap-south-1"
}

# Creating vpc, cidr and tags
resource "aws_vpc" "dev" {                  // dev = reource name to access this vpc in tf file
    cidr_block  = "10.0.0.0/16"            // vpc need a set of ip addr in form of cidr_block (2^16-2^4)
    instance_tenancy = "default"            // optional
    enable_dns_support = "true"             // optional
    enable_dns_hostnames = "true"           // optional
    tags = {
        Name = "dev"                        // this dev will create vpc in aws cloud
    }
}

# Creating public subnet in vpc 
resource "aws_subnet" "dev-public-1" {
    vpc_id     = aws_vpc.dev.id         // interpolation in terraform - call string , variable or func
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"    // true is for public subnet but for private do false
    availability_zone = "ap-south-1a"
    tags = {
      Name = "dev-public-1"
    }
}

# Create internet gateway in aws vpc
resource "aws_internet_gateway" "dev-gw" {   //internet gateway allows traffic to pas through public internet
    vpc_id = aws_vpc.dev.id                 // act as firewall
    tags = {
        Name = "dev"
  }
}

# Create route table for public subnet
resource "aws_route_table" "dev-public" {   // will route internet traffic to its destination
      vpc_id = aws_vpc.dev.id
      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev-gw.id
  }
      tags = {
        Name = "Public Route Table"
      }
}

# Create route association with public subnet
resource "aws_route_table_association" "dev-public-1-a" {   //now subnet is accessible over public internet
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}

# Create a security group to allow incoming traffic via port 22
resource "aws_security_group" "dev-security" {
  name = "SSH"
  vpc_id = aws_vpc.dev.id

  ingress {
    from_port         = 22
    to_port           = 22
    protocol          =  "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
      tags = {
        Name = "dev-security-group"
      }
}

# Create EC2 instance on public subnets
resource "aws_instance" "Demo" {
  ami                         = "ami-0cca134ec43cf708f"     // ami of amazon instance
  instance_type               = "t2.micro"
  key_name                    = "MumbaiKey"                 

  subnet_id                   = "${aws_subnet.dev-public-1.id}"
  vpc_security_group_ids      = [aws_security_group.dev-security.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "Demo1"
  }
}
