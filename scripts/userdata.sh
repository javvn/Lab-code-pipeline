#!/bin/bash

echo "start provisioning..."

sudo yum update -y
sudo yum install ruby -y
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# shellcheck disable=SC2164
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x ./install && sudo ./install auto && sudo service codedeploy-agent start