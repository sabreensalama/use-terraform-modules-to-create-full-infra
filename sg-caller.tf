module "pg_sg"{
    source = "./security-group"
    sg_name =  "postgress_sg"
    vpc_id = module.vpc.vpc_id
   ingress = [{
        description = ""
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }]
    egress = [{
        description = "egres rule"
        from_port  = 0
        to_port  = 0
        protocol   = "-1"
        cidr_blocks =  ["0.0.0.0/0"]
    }]
}

module "app_sg"{
    source = "./security-group"
    sg_name =  "app_sg"
    vpc_id = module.vpc.vpc_id
   ingress = [{
        description = ""
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }]
    egress = [{
        description = "egres rule"
        from_port  = 0
        to_port  = 0
        protocol   = "-1"
        cidr_blocks =  ["0.0.0.0/0"]
    }]
}

module "alb_sg"{
    source = "./security-group"
    sg_name =  "alb_sg"
    vpc_id = module.vpc.vpc_id
   ingress = [{
        description = ""
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }]
    egress = [{
        description = "egres rule"
        from_port  = 0
        to_port  = 0
        protocol   = "-1"
        cidr_blocks =  ["0.0.0.0/0"]
    }]
}
