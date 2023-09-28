variable "subnet_configs" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  description = "List of subnet configurations"
  default = [
    {
      name              = "subnet-1"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "subnet-2"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  ]
}


variable "ec2_configs" {
  type = list(object({
    instance_type = string
    host_name     = string
  }))
  description = "EC2 instance configuration"
  default = [{
    instance_type = "t3.micro"
    host_name     = "master1.suven.com.np"
    },
    {
      instance_type = "t3.micro"
      host_name     = "worker1.suven.com.np"
    }
  ]
}
