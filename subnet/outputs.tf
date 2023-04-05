output "subnet_id"{
    value = aws_subnet.subnet[*].id
}
output "table_id"{
    value = aws_route_table.rt.id
}
