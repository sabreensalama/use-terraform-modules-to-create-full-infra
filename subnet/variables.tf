variable "subnet_cidr_range"{
 type = list
}
variable "vpc_id"{
}
variable "map_public_ip"{
    type = list
}
variable "gateway_id"{

}
variable "count_gw"{
    default = 0
}
variable "az"{
    type  = list
}