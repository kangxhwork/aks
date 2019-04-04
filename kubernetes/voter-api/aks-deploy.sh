#!/bin/bash

# apply voter api resources part 1

# namespace
kubectl apply -f ./other/namespace.yaml

# secrets
kubectl apply \
	-f ./secrets/azure-cosmosdb-election-secret.yaml \
	-f ./secrets/azure-cosmosdb-candidate-secret.yaml \
	-f ./secrets/azure-cosmosdb-voter-secret.yaml \
	-f ./secrets/azure-service-bus-secret.yaml \
# 	-f ./secrets/tls-api-voter-demo-secret.yaml

# pods
kubectl apply \
  -f ./services/election-deployment.yaml \
  -f ./services/candidate-deployment.yaml \
  -f ./services/voter-deployment.yaml

# services
kubectl apply \
  -f ./services/election-service.yaml \
  -f ./services/candidate-service.yaml \
  -f ./services/voter-service.yaml

# ingress
kubectl apply -f ./other/ingress.yaml