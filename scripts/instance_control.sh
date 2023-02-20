#!/bin/zsh

set -e

ACTION=$1

# shellcheck disable=SC2086
if [ -z $ACTION ]; then
    echo "please input argument !"
    echo "commands:"
    echo " run"
    echo " stop"
    echo " restart"
    echo " show"
  else
    if [ $ACTION = "run" ]; then
      echo "starting instance $EC2_INSTANCE_ID..."

      (
        terraform apply -target aws_ec2_instance_state.this -target aws_eip.ec2 -target null_resource.ec2 -target module.ec2 --auto-approve
      )


    elif [ $ACTION = "stop" ]; then

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

    elif [ $ACTION = "restart" ]; then
      EC2_INSTANCE_STATE=$(aws ec2 describe-instances --filter "Name=instance-id,Values=$EC2_INSTANCE_ID" --query 'Reservations[*].Instances[*].{Instance:InstanceId,Status:State.Name}' --no-cli-pager --output text)
      echo $EC2_INSTANCE_STATE

    elif [ $ACTION = "show" ]; then
          EC2_INSTANCE_STATE=$(aws ec2 describe-instances --filter "Name=instance-id,Values=$EC2_INSTANCE_ID" --query 'Reservations[*].Instances[*].{Instance:InstanceId,Status:State.Name}' --no-cli-pager --output text)
          echo $EC2_INSTANCE_STATE

    else
      echo "Invalid input argument."
      echo "please input argument 'start' or 'stop'"
    fi
fi