resource "aws_sns_topic" "user_updates" {
  name = var.topic_name
}
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = var.protocol
  endpoint  = var.sub_endpoint
}