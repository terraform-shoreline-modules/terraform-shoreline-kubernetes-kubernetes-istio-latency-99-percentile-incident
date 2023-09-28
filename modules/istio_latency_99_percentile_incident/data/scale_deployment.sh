

#!/bin/bash



# Set the deployment name

DEPLOYMENT=${DEPLOYMENT_NAME}



# Set the desired number of replicas

REPLICAS=${DESIRED_REPLICAS}



# Scale the deployment to the desired number of replicas

kubectl scale deployment $DEPLOYMENT --replicas=$REPLICAS