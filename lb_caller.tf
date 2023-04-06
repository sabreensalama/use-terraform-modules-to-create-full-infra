module "airflow_lb"{
    source = "./lb"
    alb_name = "airflow-lb"
    vpc_id = module.vpc.vpc_id
    sg   = module.alb_sg.sg_id
    subnet_ids = [module.private_subnets.subnet_id[*]]
    port = 80
    machines_id = [module.airflow-instance-1.instance_id,module.airflow-instance-2.instance_id]
}