#!/bin/bash

# Set variables
CLUSTER_NAME=${YOUR_CLUSTER_NAME}
MEMORY_REQUEST=${NEW_MEMORY_REQUEST}
CPU_REQUEST=${NEW_CPU_REQUEST}

# Update deployment configuration
kubectl patch deployment coredns -n kube-system --patch='{"spec":{"template":{"spec":{"containers":[{"name":"coredns","resources":{"requests":{"memory":"'"$MEMORY_REQUEST"'","cpu":"'"$CPU_REQUEST"'"}}}]}}}}'

# Verify configuration update
kubectl describe deployment coredns -n kube-system