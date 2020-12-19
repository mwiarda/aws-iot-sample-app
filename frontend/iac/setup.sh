#!/bin/bash
case "$1" in
  "setup")
    template="$(cat $(dirname $0)/storage.json)"
    if aws cloudformation validate-template --template-body "$template" >/dev/null; then
        if aws cloudformation create-stack --stack-name aws-iot-sample-app-frontend-storage --template-body "$template" >/dev/null; then
            echo "I: Storage instanciated successfully"
            exit 0
        else 
            echo "E: Storage instanciation failed"
            exit 1
        fi
    else 
        echo "E: Storage template not valid"
        exit 1 
    fi
    ;;
  "delete")
    if aws cloudformation delete-stack --stack-name aws-iot-sample-app-frontend-storage >/dev/null ; then
        echo "I: Storage deleted successfully"
        exit 0
    else 
        echo "E: Could not delete storage"
        exit 1
    fi
    ;;
  *)
    echo "E: No argument specified - use either 'setup' or 'delete'."
    exit 1
    ;;
esac