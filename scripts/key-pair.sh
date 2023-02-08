#!/bin/bash
#$1 : KEY PATH/FILE
#$2 : KEY NAME

#set -e

if [ -f $1 ]
  then
    echo "existed file"
    rm $1*
      if [ $? -eq 0 ]
      then
        echo "deleted file"
      fi
  else
    echo "else"
    ssh-keygen -q -t rsa -b 2048 -m pem -C $2 -f $1 -N ""

    if [ $? -eq 0 ]
    then
      echo "generated ssh key"
      mv $1 $1.pem

      echo "importing generated ssh key to ec2 key pair..."
      aws ec2 import-key-pair --key-name $2 --public-key-material fileb://$1.pub

      if [ $? -eq 0 ]
        then
          echo "imported generated ssh key to ec2 key pair !"
        else
          aws ec2 delete-key-pair --key-name $2 && aws ec2 import-key-pair --key-name $2 --public-key-material fileb://$1.pub

          if [ $? -eq 0 ]; then echo "imported generated ssh key to ec2 key pair !"
          fi
      fi
    fi
fi