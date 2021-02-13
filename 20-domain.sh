#!/bin/sh

STACK_NAME=$1
PARAMS_FILE=params.cnf
YAML_FILE=${0//.sh/.template.yml}

HostZone=`cat $PARAMS_FILE | grep "HostZone=" | awk -F'[=]' '{print $2}'`

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$YAML_FILE \
  --parameters \
    ParameterKey=PJPrefix,ParameterValue=$STACK_NAME \
    ParameterKey=HostZone,ParameterValue=$HostZone \
    1> /dev/null
