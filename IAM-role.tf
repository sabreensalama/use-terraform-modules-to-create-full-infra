module "role_app"{
    source = "./IAM-role"
    managed_policy = ["arn:aws:iam::aws:policy/AmazonS3FullAccess" , "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    role-name  = "airflow-role"
    service = "ec2.amazonaws.com"
}
module "lambda_role"{
    source  = "./IAM-role"
    role-name = "lambda_role"
    service = "lambda.amazonaws.com"
    managed_policy = ["arn:aws:iam::aws:policy/CloudWatchFullAccess" , "arn:aws:iam::aws:policy/AmazonSNSFullAccess","arn:aws:iam::aws:policy/AmazonS3FullAccess"]

}