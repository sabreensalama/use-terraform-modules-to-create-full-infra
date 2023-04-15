resource "aws_ebs_volume" "airflow-ebs" {
  availability_zone = var.az
  size              = 20

  tags = {
    Name = "airflow-ebs"
  }
}

resource "aws_instance" "airflow-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids= var.sg_id
  iam_instance_profile = var.ec2_profile
  key_name    =   "airflow_key"
  user_data = <<EOF
    #!/bin/bash
    mkdir /ebs-data
    mkfs -t ext4 /dev/xvdh
    mount /dev/xvdh /ebs-data
    chmod -R 777 /ebs-data
    apt install unzip -y

  EOF
  depends_on = [var.depend_module]
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.airflow-ebs.id
  instance_id = aws_instance.airflow-ec2.id
}