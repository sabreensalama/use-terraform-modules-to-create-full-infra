# Create a full infrastructure using terraform modules 

## Getting started
this flow to create full infrastructure using the below diagram on multi environments:
![alt architecture](https://github.com/sabreensalama/use-terraform-modules-to-create-full-infra/blob/main/diagram.jpeg)

## componenets:
1- VPC
2- 2 private Subnets,2 public subnets
3- a private ec2 for the application on each ec2
4- installing the ssm agent on the private ec2s to connect to them privetely
5- make the private ec2s able to connect to an s3 to upload files into them
5- make the private ec2 able to connect to postgres db 
6- trigger a python lambda function by s3 upload event to send notification to sns and an sqs as a subsscriber for sns
7- load balancer to distribute the traffic to the private ec2
8- nat gateway to make the private ec2 able to egress to the internet
7- create a gitlab server to automate the creation of infrastructure

# steps to run the code from gitlab
1- you will have 3 branches with names dev, stage, prod on the repo

2- go to settings > CI/CD > Variables > add variable 
    the variable will be with key: AWS_SHARED_CREDENTIALS_FILE
    the variable with a value:
    ```
        [dev] <br />
        aws_access_key_id=<add-your-dev-access-key-id> <br />
        aws_secret_access_key=<add-your-dev-secret-access-key> <br />
        region=<Add-your-region> <br />
        [stage] <br />
        aws_access_key_id=<add-your-stage-access-key-id> <br />
        aws_secret_access_key=<add-your-stage-secret-access-key> <br />
        region=<Add-your-region> <br />
        [prod] <br />
        aws_access_key_id=<add-your-prod-access-key-id> <br />
        aws_secret_access_key=<add-your-prod-secret-access-key> <br />
        region=<Add-your-region> <br />
     ```
        
     the variable with a type: File

3- in the providers.tf change the profile to match your branch, ex on dev environment profile should be dev

4- run the .gitlab-ci.yml this will deploy all your infra
   small hint: in remote-backend you will need in the first time to apply  the s3 and dynamodb after creating them uncomment the terraform backend part to enable remote backend
######################
those steps to depoy the gitlab into an instance ec2 ubuntu:
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
sudo apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
    Next, install the GitLab package. Make sure you have correctly set up your DNS, and change https://gitlab.example.com to the URL at which you want to access your GitLab instance. Installation will automatically configure and start GitLab at that URL.
    For https:// URLs, GitLab will automatically request a certificate with Let's Encrypt, which requires inbound HTTP access and a valid hostname. You can also use your own certificate or just use http:// (without the s ).
    If you would like to specify a custom password for the initial administrator user ( root ), check the documentation. If a password is not specified, a random password will be automatically generated.

    sudo EXTERNAL_URL="http://gitlab.example.com" apt-get install gitlab-ee

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner
sudo gitlab-runner register (here make the executor is a shell)
sudo systemctl start gitlab-runner.service
sudo systemctl enable gitlab-runner.service



    



