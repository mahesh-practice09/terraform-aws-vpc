resource "aws_vpc_peering_connection" "main" {
  count = var.is_peering_required ? 1: 0
  vpc_id = aws_vpc.main.id
  peer_vpc_id = data.aws_vpc.default.id
  auto_accept = true 
  accepter {
    allow_remote_vpc_dns_resolution = true 
    
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "public_peering" {
   count = var.is_peering_required ? 1: 0
   route_table_id = aws_route_table.public_rtable.id
   destination_cidr_block = data.aws_vpc.default.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "private_peering" {
   count = var.is_peering_required ? 1: 0
   route_table_id = aws_route_table.private_rtable.id
   destination_cidr_block = data.aws_vpc.default.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "db_private_peering" {
   count = var.is_peering_required ? 1: 0
   route_table_id = aws_route_table.db_private_rtable.id
   destination_cidr_block = data.aws_vpc.default.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "default_route_peering" {
   count = var.is_peering_required ? 1: 0
   route_table_id = data.aws_route_table.default.id
   destination_cidr_block = aws_vpc.main.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}