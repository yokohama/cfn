#!/bin/sh

STACK_NAME=$1
PARAMS_FILE=params.cnf
YAML_FILE=${0//.sh/.template.yml}

VPC=`cat $PARAMS_FILE | grep "VPC=" | awk -F'[=]' '{print $2}'`
ENV_SG=`cat $PARAMS_FILE | grep "EnvironmentSecurityGroup=" | awk -F'[=]' '{print $2}'`
PUBLIC_LOAD_BLANCER_SG=`cat $PARAMS_FILE | grep "PublicLoadBalancerSecurityGroup=" | awk -F'[=]' '{print $2}'`
PUB_SUBNET1=`cat $PARAMS_FILE | grep "PublicSubnet1=" | awk -F'[=]' '{print $2}'`
PUB_SUBNET2=`cat $PARAMS_FILE | grep "PublicSubnet2=" | awk -F'[=]' '{print $2}'`

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$YAML_FILE \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=PJPrefix,ParameterValue=$STACK_NAME \
    ParameterKey=VPC,ParameterValue=$VPC \
    ParameterKey=EnvironmentSecurityGroup,ParameterValue=$ENV_SG \
    ParameterKey=PublicLoadBalancerSecurityGroup,ParameterValue=$PUBLIC_LOAD_BLANCER_SG \
    ParameterKey=PublicSubnet1,ParameterValue=$PUB_SUBNET1 \
    ParameterKey=PublicSubnet2,ParameterValue=$PUB_SUBNET2 \
  1> /dev/null
