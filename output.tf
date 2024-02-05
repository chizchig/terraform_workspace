output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "external_subnet_ids" {
  value = aws_subnet.external_subnets[*].id
}

output "internal_subnet_ids" {
  value = aws_subnet.internal_subnets[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.my_igw.id
}

output "external_route_table_ids" {
  value = aws_route_table.external_route_tables[*].id
}

output "internal_route_table_ids" {
  value = aws_route_table.internal_route_tables[*].id
}
