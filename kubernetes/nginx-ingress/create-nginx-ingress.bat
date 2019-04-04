REM Create NGINX Ingress Controller

kubectl create -f .\namespace.yaml

kubectl create ^
  -f .\tcp-services-configmap.yaml ^
  -f .\udp-services-configmap.yaml ^
  -f .\configmap.yaml

kubectl create -f .\default-backend.yaml

REM wait for default-backend to come up fully
timeout 30

kubectl create  ^
  -f .\nginx-ingress-controller.yaml ^
  -f .\nginx-ingress-controller-service.yaml
