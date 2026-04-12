variable "cidr_block" {
   type = string
}

variable "Project" {
    type = string
   
}

variable "Env" {
    type = string
  
}

variable "public_cidr_blocks" {
   type = list
}

variable "private_cidr_blocks" {
   type = list
}

variable "db_private_cidr_blocks" {
   type = list
}

variable "is_peering_required" {
   default = false
   type = bool
}