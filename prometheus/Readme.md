Prometheus is deployed to aks cluster using helm. all the services type is marked as clusterIP

to access prometheus from outside of cluster:

1. Delploy ingress controller from [helm](https://docs.microsoft.com/en-us/azure/aks/ingress-basic)： 

helm install stable/nginx-ingress --namespace monitoring --set controller.replicaCount=2

NAME                                           TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
wrapping-moose-nginx-ingress-controller        LoadBalancer   10.0.242.145   52.187.3.145   80:31224/TCP,443:30202/TCP   3m3s
wrapping-moose-nginx-ingress-default-backend   ClusterIP      10.0.63.170    <none>         80/TCP                       3m2s


2. Create NodePort type service end point 
    get the current service configuration and create necessary Serivice Entry point: kubectl get -o yaml

3. Routed by K8S ingress controller. 

