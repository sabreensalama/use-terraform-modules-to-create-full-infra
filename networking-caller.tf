module "vpc" {
    source         = "./vpc"
    vpc_cidr_range = "10.0.0.0/24"
    dns_hostname   = true
    dns_support    = true 
}
module "private_subnets"{
    source = "./subnet"
    vpc_id = module.vpc.vpc_id
    subnet_cidr_range = ["10.0.0.0/28","10.0.0.16/28"]
    map_public_ip     = [false , false ]
    gateway_id        = module.vpc.gateway_id
    az                = ["us-east-1a","us-east-1b"]

}
module "nat_module"{
    source = "./nat-gw"
    subnet_id  = element(module.public_subnets.*.subnet_id[0], 0)
    table_id = module.private_subnets.table_id
}
module "public_subnets"{
    source = "./subnet"
    vpc_id = module.vpc.vpc_id
    subnet_cidr_range = ["10.0.0.32/28","10.0.0.48/28"]
    az                = ["us-east-1c","us-east-1d"]
    map_public_ip     = [true , true ]
    gateway_id        = module.vpc.gateway_id
    count_gw = 1
}
