module "ec2_profile"{
    source = "./instance_profile"
    ec2_profile = "airflow-role" 
    ec2_role = module.role_app.role_name
    
}
module "airflow-instance-1"{
    source = "./ec2"
    ami    = "ami-006e00d6ac75d2ebb"
    instance_type = "t2.micro"
    subnet_id = module.private_subnets.subnet_id[0]
    depend_module = module.nat_module
    ec2_profile =  module.ec2_profile.profile_name
    sg_id = [module.app_sg.sg_id]

}
module "airflow-instance-2"{
    source = "./ec2"
    ami    = "ami-006e00d6ac75d2ebb"
    instance_type = "t2.micro"
    subnet_id = module.private_subnets.subnet_id[1]
    depend_module = module.nat_module
    ec2_profile =  module.ec2_profile.profile_name
    sg_id = [module.app_sg.sg_id]

}