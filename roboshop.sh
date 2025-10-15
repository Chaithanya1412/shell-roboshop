#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-009bbbd2de3309c55" #replace with your SG ID

for instance in $@
do
    INATANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

    #Get Private IP
    if [ $instance != "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids i-0afea982c1c77c59d --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids i-0afea982c1c77c59d --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    fi
    
    echo "$instance: $IP"
done