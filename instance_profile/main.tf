resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.ec2_profile
  role = var.ec2_role
}