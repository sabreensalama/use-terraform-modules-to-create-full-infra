module "triggered_lambda"{
   source = "./lambda"
   fun_name = "airflow_python_lambda"
   lambda_role = module.lambda_role.role_arn
   sns_arn  = module.sns-notification.sns_arn
   bucket_id = module.airflow_s3.s3_id

}