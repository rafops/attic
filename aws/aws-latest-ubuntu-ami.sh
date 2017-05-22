#!/bin/bash

# https://cloud-images.ubuntu.com/locator/ec2/

latest_ubuntu=`aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*" --profile default --region ca-central-1 | jq -r '.Images[].Name' | sort -r | head -n 1`

image_id=`aws ec2 describe-images --filters "Name=name,Values=$latest_ubuntu" --profile default --region ca-central-1 | jq -r '.Images[].ImageId'`

echo $image_id
