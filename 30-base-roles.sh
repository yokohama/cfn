#!/bin/sh

STACK_NAME=$1
PARAMS_FILE=params.cnf
YAML_FILE=${0//.sh/.template.yml}

VPC=`cat $PARAMS_FILE | grep "VPC=" | awk -F'[=]' '{print $2}'`

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$YAML_FILE \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=PJPrefix,ParameterValue=$STACK_NAME \
    ParameterKey=VPC,ParameterValue=$VPC \
  1> /dev/null
