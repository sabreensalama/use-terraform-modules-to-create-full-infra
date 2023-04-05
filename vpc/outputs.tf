output "vpc_id"{
    value = aws_vpc.main.id
}
output "gateway_id"{
    value = aws_internet_gateway.Igw.id
}