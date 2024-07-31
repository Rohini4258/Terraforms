#create VPC 
resource "aws_vpc" "svpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

#create IG and attach to vpc
resource "aws_internet_gateway" "sig" {
  vpc_id = aws_vpc.svpc.id
  tags = {
    Name = "my-IGW"
  }
}

#create public subnet
resource "aws_subnet" "sps" {
  vpc_id                  = aws_vpc.svpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet"
  }
}

#create Route Table
resource "aws_route_table" "srt" {
  vpc_id = aws_vpc.svpc.id
  tags = {
    Name = "my-RT"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sig.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.sps.id
  route_table_id = aws_route_table.srt.id
}

resource "aws_security_group" "ssg" {
  vpc_id      = aws_vpc.svpc.id
  name        = "allow traffic"
  description = "allow TLS inbound traffic and all outbound traffic"
  tags = {
    Name = "my-SG"
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "new" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key
  vpc_security_group_ids      = [aws_security_group.ssg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.sps.id
  availability_zone           = "us-west-2a"
  tags = {
    Name = "windows-ec2"
  }
}

