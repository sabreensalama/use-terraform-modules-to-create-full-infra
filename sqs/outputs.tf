output "queue_arn"{
    value = aws_sqs_queue.user_updates_queue.arn
}