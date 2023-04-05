resource "aws_subnet" "subnet" {
    vpc_id     = var.vpc_id
    cidr_block = var.subnet_cidr_range[count.index]
    count = length(var.subnet_cidr_range)
    map_public_ip_on_launch = var.map_public_ip[count.index] 
    availability_zone = var.az[count.index] 
    tags = {
        "Name" = "project-fiever"
    }
}

# route table private
resource "aws_route_table" "rt" {
    vpc_id = var.vpc_id

    tags =  {
        Name = "route"
    }

}

# route table association with private
resource "aws_route_table_association" "rtpv" {
    count          = length(var.subnet_cidr_range)
    subnet_id      = aws_subnet.subnet[count.index].id
    route_table_id = aws_route_table.rt.id

}
resource "aws_route" "route" {
  count = var.count_gw
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
}