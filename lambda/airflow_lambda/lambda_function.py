import boto3
import urllib
import os

# boto3 is a python library to manage AWS services
s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

def lambda_handler (event, context):

    # To retrieve the bucket name and the just uploaded file from the last event (which is the first one of the list 'Records')
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    file_name = os.path.basename(key)
    file_name = urllib.parse.unquote_plus(file_name, encoding='utf-8')

    # In this code we are trying to return the file name of the uploaded file
    message =  file_name
    print(message)

    # To associate the message to the SNS topic
    sns_response = sns_client.publish(
        TargetArn= os.environ['SNS_TOPIC_ARN'],  # Copy it from your created SNS topic
        Message= str(message),             # This will be the body of your email
        Subject= str('File Name Result')  # This will be the subject of your email
        )