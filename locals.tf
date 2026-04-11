locals {
    common_tags = {
        Project = var.Project
        Terraform = true
        Env = var.Env
    }
    vpc_final_tags = {
        Name = "${var.Project}-${var.Env}-vpc"
    }
    vpc_tags = merge(local.common_tags,local.vpc_final_tags)
    
    igw_final_tags = {
        Name = "${var.Project}-${var.Env}-igw"
    }
    
    igw_tags = merge(local.common_tags,local.igw_final_tags)

}