resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "MySQL to VPC"
    from_port   = 3306
    to_port     = 3306
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
    Name      = "allow_mysql"
    CreatedBy = "Nevus"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = aws_subnet.subnets[*].id

  tags = {
    Name      = "My DB subnet group"
    CreatedBy = "Nevus"
  }
}

resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "root"
  password               = "adminspassword129"
  parameter_group_name   = "rds-pg"
  skip_final_snapshot    = true
  availability_zone      = var.subnet_configs[0].availability_zone
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  identifier             = "mydb"
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
  tags = {
    Name      = "mydb"
    CreatedBy = "Nevus"
  }
}
