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
