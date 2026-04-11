locals {
    env = var.env
    common_tags = {
        Project = var.Project
        Terraform = true
        Env = var.env
    }
    vpc_final_tags = {
        Name = "${var.Project}-${var.env}-vpc"
    }
    vpc_tags = merge(local.common_tags,vpc_tags)
   
}