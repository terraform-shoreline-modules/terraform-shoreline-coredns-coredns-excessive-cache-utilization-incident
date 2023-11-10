
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# CoreDNS Excessive Cache Utilization Incident

This incident type typically occurs when the CoreDNS service is consuming an excessive amount of cache. CoreDNS is a flexible and extensible DNS server that is used in Kubernetes clusters for service discovery and load balancing. However, when the cache utilization becomes too high, it can result in performance degradation, service disruptions, and even system crashes. This incident requires immediate attention from the DevOps team to identify the root cause and implement a solution to prevent it from happening again.

### Parameters

```shell
export COREDNS_POD_NAME="PLACEHOLDER"
export YOUR_CLUSTER_NAME="PLACEHOLDER"
export NEW_MEMORY_REQUEST="PLACEHOLDER"
export NEW_CPU_REQUEST="PLACEHOLDER"
export CACHE_SIZE="PLACEHOLDER"
```

## Debug

### List all the pods in the default namespace

```shell
kubectl get pods
```

### Check the logs of the CoreDNS pods to see if there are any errors or warnings

```shell
kubectl logs ${COREDNS_POD_NAME}
```

### Check the resource usage of the CoreDNS pods to see if they are consuming too much memory or CPU

```shell
kubectl top pods ${COREDNS_POD_NAME}
```

### Check the CoreDNS configuration file to see if there are any misconfigurations that could be causing the excessive cache utilization

```shell
kubectl exec ${COREDNS_POD_NAME} -- cat /etc/coredns/Corefile
```

### Restart the CoreDNS pods to see if it resolves the issue temporarily

```shell
kubectl delete pod ${COREDNS_POD_NAME}
```

### Check the events log to see if there are any relevant events that could be related to the excessive cache utilization

```shell
kubectl get events
```

## Repair

### Increase the resources allocated to the Kubernetes cluster, such as memory or CPU, to accommodate the increased cache utilization.

```shell
#!/bin/bash

# Set variables
CLUSTER_NAME=${YOUR_CLUSTER_NAME}
MEMORY_REQUEST=${NEW_MEMORY_REQUEST}
CPU_REQUEST=${NEW_CPU_REQUEST}

# Update deployment configuration
kubectl patch deployment coredns -n kube-system --patch='{"spec":{"template":{"spec":{"containers":[{"name":"coredns","resources":{"requests":{"memory":"'"$MEMORY_REQUEST"'","cpu":"'"$CPU_REQUEST"'"}}}]}}}}'

# Verify configuration update
kubectl describe deployment coredns -n kube-system
```

### Configure CoreDNS to limit the maximum size of the cache to prevent it from consuming too many resources.

```shell
#!/bin/bash

# Set the maximum size of the CoreDNS cache to ${CACHE_SIZE} bytes
CACHE_SIZE=${CACHE_SIZE}
kubectl set env deployment/coredns -n kube-system COREDNS_ARGS="-cache-size $CACHE_SIZE"

# Verify that the configuration has been applied
kubectl rollout status deployment/coredns -n kube-system
```