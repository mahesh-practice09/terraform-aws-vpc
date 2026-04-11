variable "cidr_block" {
   default = "10.0.0.0/16"
   type = string
}

variable "Project" {
    type = string
    default = "Roboshop"
}

variable "Env" {
    type = string
    default = "dev"
}

