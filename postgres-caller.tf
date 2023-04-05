  module "postgres"{
    source  = "./postgres"
    storage = 10
    identifier  = "airflow-db"
    engine  = "postgres"
    engine_version =  "15"
    instance_type = "db.t3.micro"
    subnet_id  = module.private_subnets.subnet_id
    sg = [module.pg_sg.sg_id]
  }
