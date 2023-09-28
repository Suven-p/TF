resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "SSH to VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS to VPC"
    from_port   = 443
    to_port     = 443
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
    Name      = "allow_http_ssh"
    CreatedBy = "Nevus"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  subnet_ids = [for subnet in aws_subnet.subnets : subnet.id]
}

resource "aws_instance" "app_server" {
  count                       = length(var.ec2_configs)
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = var.ec2_configs[count.index].instance_type
  subnet_id                   = local.subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id, aws_security_group.k3s_security_group.id]
  key_name                    = "TerraformTestKey"
  user_data                   = <<EOF
#!/bin/bash
sudo hostnamectl set-hostname ${var.ec2_configs[count.index].host_name} > /home/ubuntu/hostname.log 2>&1
EOF
  user_data_replace_on_change = true

  tags = {
    Name      = "AppServerInstance"
    CreatedBy = "Nevus"
    HostName  = var.ec2_configs[count.index].host_name
  }
}
