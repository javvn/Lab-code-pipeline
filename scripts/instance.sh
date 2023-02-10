#!/bin/zsh

set -e

# start or stop
ACTION=$1
EC2_INSTANCE_ID=$(terraform output -json | jq -r .ec2.value.id)
EC2_INSTANCE_STATE=$(aws ec2 describe-instances --filter "Name=instance-id,Values=$EC2_INSTANCE_ID" --query 'Reservations[*].Instances[*].{Status:State.Name}' --no-cli-pager --output text)


# shellcheck disable=SC2086
if [ -z $ACTION ]; then
    echo "please input argument 'start' or 'stop'"
  else
    if [ $ACTION = "start" ]; then
      echo "starting instance $EC2_INSTANCE_ID..."
        aws ec2 start-instances --instance-ids $EC2_INSTANCE_ID --no-cli-pager
        # shellcheck disable=SC2181
        if [ $? -eq 0 ]; then

          while [ $EC2_INSTANCE_STATE != "running" ]
          do
            sleep 2
            echo "starting instance $EC2_INSTANCE_ID..."
            EC2_INSTANCE_STATE=$(aws ec2 describe-instances --filter "Name=instance-id,Values=$EC2_INSTANCE_ID" --query 'Reservations[*].Instances[*].{Status:State.Name}' --no-cli-pager --output text)
          done

          echo "started instance !"
          terraform apply -target module.ec2 -target aws_eip.ec2 -target null_resource.ec2 --auto-approve
        fi

    elif [ $ACTION = "stop" ]; then
      aws ec2 stop-instances --instance-ids $EC2_INSTANCE_ID --no-cli-pager
      if [ $? -eq 0 ]; then
          while [ $EC2_INSTANCE_STATE != "stopped" ]
            do
               sleep 2
               echo "stopping instance... $EC2_INSTANCE_ID"
               EC2_INSTANCE_STATE=$(aws ec2 describe-instances --filter "Name=instance-id,Values=$EC2_INSTANCE_ID" --query 'Reservations[*].Instances[*].{Status:State.Name}' --no-cli-pager --output text)
          done
          echo "stopped instance !"
          (
            terraform apply -target module.ec2 --auto-approve &&
            terraform apply -destroy -target aws_eip.ec2 --auto-approve &&
            echo "success !"
          )
      fi
    elif [ $ACTION = "show" ]; then
      EC2_INSTANCE_STATE=$(aws ec2 describe-instances --filter "Name=instance-id,Values=$EC2_INSTANCE_ID" --query 'Reservations[*].Instances[*].{Instance:InstanceId,Status:State.Name}' --no-cli-pager --output text)
      echo $EC2_INSTANCE_STATE
    else
      echo "Invalid input argument."
      echo "please input argument 'start' or 'stop'"
    fi
fi