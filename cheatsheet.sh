#!/bin/bash, dX2iSKg0ynjFQ

# install osba https://docs.microsoft.com/en-us/azure/aks/integrate-azure

helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
helm install svc-cat/catalog --name catalog --namespace catalog --set apiserver.storage.etcd.persistence.enabled=true --set apiserver.healthcheck.enabled=false --set controllerManager.healthcheck.enabled=false --set apiserver.verbosity=2 --set controllerManager.verbosity=2
kubectl get apiservice | grep service


helm repo add azure https://kubernetescharts.blob.core.windows.net/azure
az ad sp create-for-rbac
{
  "appId": "11c1c779-58a7-4fe8-860c-557e2e6f16c7",
  "displayName": "azure-cli-2019-04-06-02-26-10",
  "name": "http://azure-cli-2019-04-06-02-26-10",
  "password": "2186b8ab-48ac-4698-94cb-ecbe762210c0",
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db47"
}

AZURE_CLIENT_ID=11c1c779-58a7-4fe8-860c-557e2e6f16c7
AZURE_CLIENT_SECRET=2186b8ab-48ac-4698-94cb-ecbe762210c0
AZURE_TENANT_ID=72f988bf-86f1-41af-91ab-2d7cd011db47
AZURE_SUBSCRIPTION_ID=9c6835cb-2079-4f99-96f4-74029267e0df

helm install azure/open-service-broker-azure --name osba --namespace osba \
    --set azure.subscriptionId=$AZURE_SUBSCRIPTION_ID \
    --set azure.tenantId=$AZURE_TENANT_ID \
    --set azure.clientId=$AZURE_CLIENT_ID \
    --set azure.clientSecret=$AZURE_CLIENT_SECRET

curl -sLO https://servicecatalogcli.blob.core.windows.net/cli/latest/$(uname -s)/$(uname -m)/svcat
chmod +x ./svcat

./svcat get brokers 
  NAME                                URL                                STATUS  
+------+---------------------------------------------------------------+--------+
  osba   https://osba-open-service-broker-azure.osba.svc.cluster.local   Ready   

./svcat get plans
./svcat get classes

kubectl get clusterservicebroker -o yaml
kubectl get clusterserviceclasses -o=custom-columns=NAME:.metadata.name,EXTERNAL\ NAME:.spec.externalName
kubectl get clusterserviceplans -o=custom-columns=NAME:.metadata.name,EXTERNAL\ NAME:.spec.externalName,SERVICE\ CLASS:.spec.clusterServiceClassRef.name --sort-by=.spec.clusterServiceClassRef.name



##########################################

# namespace
kubectl apply -f ./other/namespace.yaml

# secrets
kubectl apply -f ./secrets/azure-cosmosdb-election-secret.yaml
kubectl apply -f ./secrets/azure-cosmosdb-candidate-secret.yaml
kubectl apply -f ./secrets/azure-cosmosdb-voter-secret.yaml
kubectl apply -f ./secrets/azure-service-bus-secret.yaml

# verify secrets data
kubectl get secret -n voter-api 

# create Pod with Deployment
kubectl apply -f ./services/election-deployment.yaml
kubectl apply -f ./services/candidate-deployment.yaml
kubectl apply -f /services/voter-deployment.yaml

# verify deployment and pod
kubectl get deployment -n voter-api -o wide
kubectl get pod -n voter-api -o wide








