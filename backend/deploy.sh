#!/bin/bash
case "$1" in
  "deploy")
    
    # Deploy storage
    template="$(cat $(dirname $0)/iac/storage.json)"
    if aws cloudformation create-stack --stack-name aws-iot-sample-app-backend-storage --template-body "$template" >/dev/null; then
        if aws cloudformation wait stack-create-complete --stack-name "aws-iot-sample-app-backend-storage" ; then
            echo "I: Backend storage instanciated successfully"
        else 
            echo "E: Backend storage instanciation failed"
            exit 1
        fi 
    else 
        echo "E: Backend storage instanciation failed"
        exit 1
    fi
    
    rm -r $(dirname $0)/deployment &>/dev/null 
    mkdir $(dirname $0)/deployment &>/dev/null 
    zip -r -j -D $(dirname $0)/deployment/aws-iot-sample-app-backend.zip $(dirname $0)/src/*

    aws s3 cp $(dirname $0)/deployment/aws-iot-sample-app-backend.zip s3://aws-iot-sample-app-backend-code-storage/ 
    
    template="$(cat $(dirname $0)/iac/lamda.json)"
    if aws cloudformation create-stack --capabilities "CAPABILITY_NAMED_IAM" --stack-name aws-iot-sample-app-backend --template-body "$template" >/dev/null; then
        if aws cloudformation wait stack-create-complete --stack-name "aws-iot-sample-app-backend" ; then
            echo "I: Backend lamda instanciated successfully"
        else 
            echo "E: Backend lamda instanciation failed"
            exit 1
        fi 
    else 
        echo "E: Backend lamda instanciation failed"
        exit 1
    fi
    
    ;;
  "delete")
    if aws cloudformation delete-stack --stack-name aws-iot-sample-app-backend >/dev/null ; then
        echo "I: Backend lambda deleted successfully"
    else 
        echo "E: Could not delete backend"
        exit 1
    fi
    
    aws s3 rm s3://aws-iot-sample-app-backend-code-storage/ --recursive

    if aws cloudformation delete-stack --stack-name aws-iot-sample-app-backend-storage >/dev/null ; then
        echo "I: Backend storage deleted successfully"
    else 
        echo "E: Could not delete backend"
        exit 1
    fi
    ;;
  *)
    echo "E: No argument specified - use either 'deploy' or 'delete'."
    exit 1
    ;;
esac