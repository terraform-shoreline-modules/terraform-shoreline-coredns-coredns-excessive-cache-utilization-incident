#!/bin/bash

# Set the maximum size of the CoreDNS cache to ${CACHE_SIZE} bytes
CACHE_SIZE=${CACHE_SIZE}
kubectl set env deployment/coredns -n kube-system COREDNS_ARGS="-cache-size $CACHE_SIZE"

# Verify that the configuration has been applied
kubectl rollout status deployment/coredns -n kube-system