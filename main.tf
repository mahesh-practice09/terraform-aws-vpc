resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = local.vpc_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = local.igw_tags
}

resource "aws_eip" "main" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.allocation_id
  subnet_id     = aws_subnet.public_subnet[0].id


  depends_on = [aws_internet_gateway.main]

    tags = merge(
    {
      Name = "${var.Project}-${var.Env}-nat-gw"
    },
    local.common_tags
  )
}

 resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  map_public_ip_on_launch = true
  cidr_block = var.public_cidr_blocks[count.index]
  availability_zone = local.selected_zones[count.index]
  
  tags = merge(
    {
      Name = "${var.Project}-${var.Env}-public-snet-${local.selected_zones[count.index]}",
    },
    local.common_tags
  )
}      
  
 resource "aws_subnet" "private_subnet" {
  count = length(var.private_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_blocks[count.index]
  availability_zone = local.selected_zones[count.index]
  tags =merge(
    {
      Name = "${var.Project}-${var.Env}-private-snet-${local.selected_zones[count.index]}",
    },
    local.common_tags
  )
 
}      

 resource "aws_subnet" "db_private_subnet" {
  count = length(var.db_private_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_private_cidr_blocks[count.index]
  availability_zone = local.selected_zones[count.index]
  tags = merge(
    {
      Name = "${var.Project}-${var.Env}-db-private-snet-${local.selected_zones[count.index]}",
    },
    local.common_tags
  )
 
}  

resource "aws_route_table" "public_rtable" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${var.Project}-${var.Env}-public-rtable"
    },
    local.common_tags
  )
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
  route_table_id = aws_route_table.public_rtable.id
}

resource "aws_route_table" "private_rtable" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${var.Project}-${var.Env}-private-rtable"
    },
    local.common_tags
  )
}

resource "aws_route" "private" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
  route_table_id = aws_route_table.private_rtable.id
}

resource "aws_route_table" "db_private_rtable" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${var.Project}-${var.Env}-db-private-rtable"
    },
    local.common_tags
  )
}


resource "aws_route" "db_private" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
  route_table_id = aws_route_table.db_private_rtable.id
}

resource "aws_route_table_association" "public_rt_assoc" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rtable.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rtable.id
}


resource "aws_route_table_association" "db_private_rt_assoc" {
  count = length(aws_subnet.db_private_subnet)
  subnet_id      = aws_subnet.db_private_subnet[count.index].id
  route_table_id = aws_route_table.db_private_rtable.id
}