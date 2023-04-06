# resource "aws_s3_bucket" "terraform_state_remote" {
#   bucket = "terraform-state-remot-dev"

#   # Prevent accidental deletion of this S3 bucket
#   /* lifecycle {
#     prevent_destroy = true
#   } */
# }
# resource "aws_s3_bucket_versioning" "enabled" {
#   bucket = aws_s3_bucket.terraform_state_remote.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform_state_remote_dev"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-state-remot-dev"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    profile = "dev"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform_state_remote_dev"
    encrypt        = true
  }
}
