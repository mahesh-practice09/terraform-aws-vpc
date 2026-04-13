output "available_zones" {
  value = data.aws_availability_zones.available.names
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id 
}

output "db_private_subnet_ids" {
  value = aws_subnet.db_private_subnet[*].id
}