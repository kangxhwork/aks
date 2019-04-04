#!/bin/bash

# namespace
kubectl apply -f ./other/namespace.yaml

# voter
kubectl apply -f ./secrets/azure-cosmosdb-voter-secret.yaml
kubectl apply -f ./services/voter-deployment.yaml
kubectl apply -f ./services/voter-service.yaml


# ingress
# kubectl apply -f ./other/ingress.yaml