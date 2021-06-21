#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-redisTest}
PROJECTNAME=${2:-redisTest}
VPC=${3:-vpc-e7e0698c}
SUBNETS=${4:-subnet-47fcab0b,subnet-c99627a2,subnet-4931de34}
ENVIRONMENT=${5:-development}
CREATOR=${6:-CloudFormation}
TEMPLATELOCATION=${7:-file://$(pwd)/elasticache.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --disable-rollback \
                                        --region us-east-2 \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=Subnets,ParameterValue=\"$SUBNETS\" \
                                                     ParameterKey=VPC,ParameterValue=$VPC \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
