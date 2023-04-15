# Create a full infrastructure using terraform modules 

## Getting started
> this flow to create full infrastructure using the below diagram on multi environments:
![alt architecture](https://github.com/sabreensalama/use-terraform-modules-to-create-full-infra/blob/main/diagram.jpeg)

## componenets:
1. VPC
2. 2 private Subnets,2 public subnets
3. a private ec2 for the application on each subne
4. installing the ssm agent on the private ec2s to connect to them securely
5. make the private ec2s able to communicate  to an s3 to upload files into them
5. make the private ec2 able to connect to postgres db 
6. trigger a python lambda function by s3 upload event to send a notification to SNS and an sqs as a subscriber for SNS
7. load balancer to distribute the traffic to the private ec2
8. nat gateway to make the private ec2 able to egress to the internet
7. create a GitLab server to automate the creation of infrastructure

# steps to run the code from gitlab
1- you will have 3 branches with names dev, stage, prod on the repo

2- go to settings > CI/CD > Variables > add variable 
  ```
    a- the variable will be with key: AWS_SHARED_CREDENTIALS_FILE 
    b- the variable with a value:
        [dev] 
        aws_access_key_id=<add-your-dev-access-key-id> 
        aws_secret_access_key=<add-your-dev-secret-access-key>
        region=<Add-your-region> 
        [stage] 
        aws_access_key_id=<add-your-stage-access-key-id> 
        aws_secret_access_key=<add-your-stage-secret-access-key> 
        region=<Add-your-region> 
        [prod] 
        aws_access_key_id=<add-your-prod-access-key-id> 
        aws_secret_access_key=<add-your-prod-secret-access-key> 
        region=<Add-your-region>   
     
        
   c- the variable with a type: File
   ```

3- in the providers.tf change the profile to match your branch, ex on dev environment profile should be dev <br>
4- you will need to add a three parameters to ssm parameter store with the names /postgres/username, /postgres/password , /postgres/db_name <br>
  > **_NOTE:_**  go to the SSM Parameters Store console and add a new parameter. Give it a name and set the type to be SecureString. <br>
  
5- run the .gitlab-ci.yml this will deploy all your infra

 > **_NOTE:_**  in remote-backend you will need in the first time to apply  the s3 and dynamodb after creating them uncomment the terraform backend part to enable remote backend  <br>
 
 > **_NOTE:_**  you may need to install the awscli in your private machines: apt install awscli to send apis to the s3 <br>

> **_NOTE:_** you need to create a key pair manually from the aws console with the name airflow_key before running the Infra pipeline
 
those steps to depoy the gitlab into an instance ec2 ubuntu(you need to create your ec2 first):
 ```
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
 ```
# Extra Part

in the private machines , we need to execute thos commands for ebs:
```
    mkdir /ebs-data
    mkfs -t ext4 /dev/xvdh
    mount /dev/xvdh /ebs-data
    chmod -R 777 /ebs-data
    apt install unzip -y
```
> **_NOTE:_**  you need to define some variables for the following pipeline from CICD then variables:
  - SSH_PRIVATE_KEY 
      value: <your-pem-airlfow_key_value>
  - EC2_IPADDRESS
      value: <ip-of-privat-machine>

for the python pipeline use the below .gitlab-ci.yml:
```
stages:
  - deploy

Deploy: 
  stage: deploy
  before_script:
  - 'command -v ssh-agent >/dev/null || ( apk add --update openssh )' 
  - eval $(ssh-agent -s)
  - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
  - mkdir -p ~/.ssh
  - chmod 700 ~/.ssh
  - ssh-keyscan $EC2_IPADDRESS >> ~/.ssh/known_hosts
  - chmod 644 ~/.ssh/known_hosts
  -  sudo apt install zip  -y
  - sudo apt install unzip -y
   
  script:
    - mkdir dags
    - git clone <your-repo-url> dags

    - zip -r dags.zip .
    - ssh -o StrictHostKeyChecking=no ubuntu@$EC2_IPADDRESS "test -d "/ebs-data/dags" && echo "Found/Exists" || sudo mkdir /ebs-data/dags"
    - scp -o StrictHostKeyChecking=no dags.zip ubuntu@$EC2_IPADDRESS:/ebs-data/dags
    - ssh -o StrictHostKeyChecking=no ubuntu@$EC2_IPADDRESS "cd /ebs-data/dags; unzip dags.zip"
```
 > **_NOTE:_**  for git clone you will put your repo url from gitlab like this one http://<gitlab-user>:<gitlab-password>@<gitlab-server-ip>/gitlab-instance-b944c199/<your-repo>.git<br>


    



