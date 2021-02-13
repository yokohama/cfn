#!/bin/sh

STACK_NAME=$1
PARAMS_FILE=params.cnf
YAML_FILE=${0//.sh/.template.yml}

PUB_SUBNET1=`cat $PARAMS_FILE | grep "PublicSubnet1=" | awk -F'[=]' '{print $2}'`
PUB_SUBNET2=`cat $PARAMS_FILE | grep "PublicSubnet2=" | awk -F'[=]' '{print $2}'`
ENV_SG=`cat $PARAMS_FILE | grep "EnvironmentSecurityGroup=" | awk -F'[=]' '{print $2}'`
CLUSTER_ID=`cat $PARAMS_FILE | grep "ProductionClusterId=" | awk -F'[=]' '{print $2}'`
TARGET_G=`cat $PARAMS_FILE | grep "FrontProductionDefaultHTTPTargetGroupArn" | awk -F'[=]' '{print $2}'`

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$YAML_FILE \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=PJPrefix,ParameterValue=$STACK_NAME \
    ParameterKey=PublicSubnet1,ParameterValue=$PUB_SUBNET1 \
    ParameterKey=PublicSubnet2,ParameterValue=$PUB_SUBNET2 \
    ParameterKey=EnvironmentSecurityGroup,ParameterValue=$ENV_SG \
    ParameterKey=ProductionClusterId,ParameterValue=$CLUSTER_ID \
    ParameterKey=TargetGroup,ParameterValue=$TARGET_G \
  1> /dev/null
