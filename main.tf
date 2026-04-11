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


 resource "aws_subnet" "public_subnet" {
  count = var.public_cidr_blocks
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_blocks[count.index]
  
  tags = {
      Name = "${var.Project}-${var.Env}-public-snet-${local.selected_zones[count-index]}"
  }
 
}      
  
 resource "aws_subnet" "private_subnet" {
  count = var.private_cidr_blocks
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_blocks[count.index]
  
  tags = {
      Name = "${var.Project}-${var.Env}-private-snet-${local.selected_zones[count-index]}"
  }
 
}      

 resource "aws_subnet" "db_private_subnet" {
  count = var.db_private_cidr_blocks
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_private_cidr_blocks[count.index]
  
  tags = {
      Name = "${var.Project}-${var.Env}-db-private-snet-${local.selected_zones[count-index]}"
  }
 
}  