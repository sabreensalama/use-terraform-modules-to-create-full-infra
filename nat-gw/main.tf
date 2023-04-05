# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_id
  tags = {
    Name        = "nat"
  }
}
resource "aws_route" "route" {
  route_table_id         = var.table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}