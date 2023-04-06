

resource "aws_lambda_function" "get_latest_filename" {
  filename      = "./lambda/lambda_function.py.zip"
  function_name = var.fun_name
  role          = var.lambda_role
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_arn
    }
  }
  source_code_hash = filebase64sha256("./lambda/lambda_function.py.zip")
}


resource "aws_s3_bucket_notification" "bucket" {
  bucket = var.bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.get_latest_filename.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_latest_filename.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_id}"
}
