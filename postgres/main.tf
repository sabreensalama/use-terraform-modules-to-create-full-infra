 data "aws_ssm_parameter" "pg_username" {
  name = "/postgres/username"
}
data "aws_ssm_parameter" "pg_password" {
  name = "/postgres/password"
}
data "aws_ssm_parameter" "db_name" {
  name = "/postgres/db_name"
} 
resource "aws_db_subnet_group" "subnet_group" {
  name       = "airflow-group"
  subnet_ids = var.subnet_id

  tags = {
    Name = "airflow"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = var.storage
  db_name              = data.aws_ssm_parameter.db_name.value
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_type
  username             = data.aws_ssm_parameter.pg_username.value
  password             = data.aws_ssm_parameter.pg_password.value
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = var.sg


}
