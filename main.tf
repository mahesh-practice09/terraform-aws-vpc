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

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.main.allocation_id
  subnet_id     = aws_subnet.public_subnet[count.index].id


  depends_on = [aws_internet_gateway.main]
}

 resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr_blocks)
  vpc_id     = aws_vpc.main.id
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

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    {
      Name = "${var.Project}-${var.Env}-public-rtable"
    },
    local.common_tags
  )
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

resource "aws_route_table" "db_private_rtable" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${var.Project}-${var.Env}-db-private-rtable"
    },
    local.common_tags
  )
}

