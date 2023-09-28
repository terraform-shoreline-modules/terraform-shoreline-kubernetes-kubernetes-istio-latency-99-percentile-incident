
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Istio Latency 99 Percentile Incident
---

This incident type refers to an issue where Istio latency has exceeded the 99th percentile, indicating that the slowest 1% of requests are taking longer than 1 second to complete. This can cause performance issues and impact the user experience. It requires immediate attention and investigation to resolve the issue and prevent any further impact.

### Parameters
```shell
export ISTIO_LABEL="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export ISTIO_MIXER_POD_NAME="PLACEHOLDER"

export ISTIO_TELEMETRY_POD_NAME="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export DESIRED_REPLICAS="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"
```

## Debug

### 1. Check Istio version
```shell
istioctl version
```

### 2. Get Istio pod status
```shell
kubectl -n ${NAMESPACE} get pods -l ${ISTIO_LABEL}
```

### 3. Check Istio telemetry service status
```shell
kubectl -n ${NAMESPACE} get svc prometheus
```

### 4. Check Istio telemetry configuration
```shell
kubectl -n ${NAMESPACE} get svc istio-telemetry -o yaml
```

### 5. Check Istio Mixer config
```shell
kubectl -n ${NAMESPACE} get configmap istio -o yaml
```

### 6. Check Istio Mixer log
```shell
kubectl -n ${NAMESPACE} logs ${ISTIO_MIXER_POD_NAME}
```

### 7. Check Istio gateway configuration
```shell
kubectl -n ${NAMESPACE} get gateway
```

### 8. Check Istio virtual service configuration
```shell
kubectl -n ${NAMESPACE} get virtualservice
```

### 9. Check Istio destination rule configuration
```shell
kubectl -n ${NAMESPACE} get destinationrule
```

### 10. Check Istio metrics
```shell
kubectl -n ${NAMESPACE} exec -it ${ISTIO_TELEMETRY_POD_NAME} -c prometheus -- curl http://localhost:9090/metrics
```

### 11. Check Istio logs for specific pod
```shell
kubectl -n ${NAMESPACE} logs ${POD_NAME} -c istio-proxy
```

### Resource constraints: The Istio service may be experiencing resource constraints. For example, if there are not enough resources allocated to the service, it could result in increased latency.
```shell


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


```

## Repair

### Scale up or down resources as necessary to ensure optimal system performance.
```shell


#!/bin/bash



# Set the deployment name

DEPLOYMENT=${DEPLOYMENT_NAME}



# Set the desired number of replicas

REPLICAS=${DESIRED_REPLICAS}



# Scale the deployment to the desired number of replicas

kubectl scale deployment $DEPLOYMENT --replicas=$REPLICAS


```