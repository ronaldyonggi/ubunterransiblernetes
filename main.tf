# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "credentials"
}


  # Create a vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "my_vpc"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_gateway"
  }
}

# Create route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name = "my_route_table"
  }
}

# Create subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my_subnet"
  }
}
#  Associate subnet with route table
resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create Security Group allowing EVERYTHING
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow EVERYTHING"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #-1 means any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}

#  Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "my_network_interface" {
  subnet_id       = aws_subnet.my_subnet.id
  private_ips     = ["10.0.1.50"] # any ip address within subnet
  security_groups = [aws_security_group.my_security_group.id]
}

resource "aws_instance" "my_instance" {
  ami = var.my_ami
  instance_type = "t3a.small"
  key_name = "keypair"
  associate_public_ip_address = true
  subnet_id = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_security_group.id]

  provisioner "remote-exec" {
      inline = ["echo 'Wait until SSH is ready'"]
      
      connection {
          type = "ssh"
          user = "ubuntu"
          # Make sure the keypath below is NOT WITHIN the ubunterransiblernetes directory. 
          # in this case it's one directory above.
          private_key = file(var.my_keypath)
          host = aws_instance.my_instance.public_ip
      }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.my_instance.public_ip}, --private-key ${var.my_keypath} main.yaml"
  }

  tags = {
    Name = "Project"
  }
}