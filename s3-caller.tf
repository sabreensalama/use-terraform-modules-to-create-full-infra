module "airflow_s3"{
    source = "./s3"
    bucket_name = "airflow-dags-s3"
    acl =  "private"
}