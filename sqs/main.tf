resource "aws_sqs_queue" "user_updates_queue" {
  name = var.queue_name
    visibility_timeout_seconds = 300
}
resource "aws_sqs_queue_policy" "results_updates_queue_policy" {
    queue_url = "${aws_sqs_queue.user_updates_queue.id}"

    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.user_updates_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.sns_arn}"
        }
      }
    }
  ]
}
POLICY
}