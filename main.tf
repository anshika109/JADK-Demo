provider "aws" {
    region = "ap-south-1"
}

# Create EC2 instance on public subnets
resource "aws_instance" "Demo" {
  ami                         = "ami-0cca134ec43cf708f"     // ami of amazon instance
  instance_type               = "t2.micro"
  key_name                    = "MumbaiKey"                  
  tags = {
    Name = "Demo1"
  }
}
