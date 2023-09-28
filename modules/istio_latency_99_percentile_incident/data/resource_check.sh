

#!/bin/bash



# Set the namespace and deployment name for Istio

NAMESPACE=${NAMESPACE}

DEPLOYMENT_NAME=${DEPLOYMENT_NAME}



# Check the resource limits and usage for the Istio deployment

echo "Checking resource limits and usage for Istio deployment..."

kubectl describe deployment $DEPLOYMENT_NAME -n $NAMESPACE | grep -E 'Limits|Requests|CPU|Memory'



# Check the resource requests and limits for the Istio containers

echo "Checking resource requests and limits for Istio containers..."

kubectl describe pods -l app=$DEPLOYMENT_NAME -n $NAMESPACE | grep -E 'Limits|Requests|CPU|Memory'



# Check the resource usage for the Istio containers

echo "Checking resource usage for Istio containers..."

kubectl top pods -n $NAMESPACE | grep $DEPLOYMENT_NAME