#!/bin/bash, dX2iSKg0ynjFQ  CBTTGbfLtswbZvIAfe5Lk/YEPwpGILxUToNkVjdDI5w=

# Setup environment
Jenkins: http://kangxhpipseaoss.southeastasia.cloudapp.azure.com:8080
Grafana: http://kangxhpipseaoss.southeastasia.cloudapp.azure.com:3000 admin

prometheus-alertmanager         ClusterIP   10.0.87.231    <none>        80/TCP     5h13m
prometheus-pushgateway          ClusterIP   10.0.207.178   <none>        9091/TCP   5h13m
prometheus-server               ClusterIP   10.0.68.176    <none>        80/TCP     5h13m

kubectl --namespace monitoring port-forward prometheus-server-8666645ff5-cgm6z 9090

az aks browse --resource-group az-rg-kangxh-aks --name kangxhakssea



### Manage ACR
az acr login --name kangxhacrseasudo 
az acr list --resource-group az-rg-kangxh-aks --query "[].{acrLoginServer:loginServer}" --output table
sudo docker tag kangxh/azure-vote-front kangxhacrsea.azurecr.io/azure-vote-front
az acr repository list --name kangxhacrsea --output table
az acr repository show-tags --name kangxhacrsea --repository azure-vote-front --output table

### check kubernetes cluster
kubectl get node -o wide
kubectl get pod -n voting -o wide
kubectl get service -n voting -o wide

################## install osba https://docs.microsoft.com/en-us/azure/aks/integrate-azure  #########################

helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
helm install svc-cat/catalog --name catalog --namespace catalog --set apiserver.storage.etcd.persistence.enabled=true --set apiserver.healthcheck.enabled=false --set controllerManager.healthcheck.enabled=false --set apiserver.verbosity=2 --set controllerManager.verbosity=2
kubectl get apiservice | grep service


helm repo add azure https://kubernetescharts.blob.core.windows.net/azure
az ad sp create-for-rbac
{
  "appId": "11c1c779-58a7-4fe8-860c-557e2e6f16c7",
  "password": "2186b8ab-48ac-4698-94cb-ecbe762210c0",
}

helm install azure/open-service-broker-azure --name osba --namespace osba \
    --set azure.subscriptionId=$AZURE_SUBSCRIPTION_ID \
    --set azure.tenantId=$AZURE_TENANT_ID \
    --set azure.clientId=$AZURE_CLIENT_ID \
    --set azure.clientSecret=$AZURE_CLIENT_SECRET

curl -sLO https://servicecatalogcli.blob.core.windows.net/cli/latest/$(uname -s)/$(uname -m)/svcat
chmod +x ./svcat

./svcat get brokers 
./svcat get plans
./svcat get classes

kubectl get clusterservicebroker -o yaml
kubectl get clusterserviceclasses -o=custom-columns=NAME:.metadata.name,EXTERNAL\ NAME:.spec.externalName
kubectl get clusterserviceplans -o=custom-columns=NAME:.metadata.name,EXTERNAL\ NAME:.spec.externalName,SERVICE\ CLASS:.spec.clusterServiceClassRef.name --sort-by=.spec.clusterServiceClassRef.name


#################  Create Voting App  #########################



#################  Create Voting App  #########################



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









