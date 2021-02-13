#!/bin/sh

STACK_NAME=$1
YAML_FILE=${0//.sh/.template.yml}

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$YAML_FILE \
  --parameters \
    ParameterKey=PJPrefix,ParameterValue=$STACK_NAME \
  1> /dev/null
