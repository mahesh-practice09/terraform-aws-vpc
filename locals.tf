locals {
   
    public_cidr_blocks = [ "10.0.1.0/24","10.0.2.0/24"]
    private_cidr_blocks = [ "10.0.11.0/24","10.0.12.0/24"]
    db_private_cidr_blocks = [ "10.0.21.0/24","10.0.22.0/24"]

      common_tags = {
        Project = var.Project
        Terraform = true
        Env = var.Env
    }
    vpc_final_tags = {
        Name = "${var.Project}-${var.Env}-vpc"
    }
    vpc_tags = merge(local.common_tags,local.vpc_final_tags)

    selected_zones = slice(data.aws_availability_zones.available.names,0,2)
    
    igw_final_tags = {
        Name = "${var.Project}-${var.Env}-igw"
    }
    
    igw_tags = merge(local.common_tags,local.igw_final_tags)
    
}