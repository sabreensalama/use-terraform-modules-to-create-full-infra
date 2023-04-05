resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_range
  enable_dns_hostnames =  var.dns_hostname
  enable_dns_support   = var.dns_support
  tags = {
    Name = "main"
  }
}
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}