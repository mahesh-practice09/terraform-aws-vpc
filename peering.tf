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