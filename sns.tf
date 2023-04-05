module "sqs"{
    source    = "./sqs"
    queue_name = "notification-of-app-s3"
    sns_arn = module.sns-notification.sns_arn
   
}

module "sns-notification"{
    source = "./sns"
    topic_name = "notification-of-app-s3"
    protocol = "sqs"
    sub_endpoint = module.sqs.queue_arn
}