#!/bin/bash
case "$1" in
  "deploy")
    $(dirname $0)/iac/deploy.sh setup
    aws s3 cp $(dirname $0)/src/ s3://aws-iot-sample-app-frontend-storage/ --recursive
    ;;
  "delete")
    aws s3 rm s3://aws-iot-sample-app-frontend-storage/ --recursive
    $(dirname $0)/iac/deploy.sh delete
    ;;
  *)
    echo "E: No argument specified - use either 'deploy' or 'delete'."
    exit 1
    ;;
esac