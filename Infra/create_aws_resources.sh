#!/bin/bash

stack_name="SOC-landing"
template_file="resources.yaml"

if aws cloudformation --profile password-generator-app-pipeline-user describe-stacks --stack-name "$stack_name" > /dev/null 2>&1; then
  echo "Stack $stack_name exists. Updating..."
  aws cloudformation -- profile password-generator-app-pipeline-user update-stack --stack-name "$stack_name" --template-body "file://$template_file"
else
  echo "Stack $stack_name does not exist. Creating..."
  aws cloudformation --profile password-generator-app-pipeline-user create-stack --stack-name "$stack_name" --template-body "file://$template_file"

fi
