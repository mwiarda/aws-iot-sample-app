#!/bin/bash
frontend_dir=$(dirname $0)/frontend
case "$1" in
  "deploy")
    $frontend_dir/deploy.sh deploy
    ;;
  "delete")
    $frontend_dir/deploy.sh delete
    ;;
  *)
    echo "E: No argument specified - use either 'deploy' or 'delete'."
    exit 1
    ;;
esac