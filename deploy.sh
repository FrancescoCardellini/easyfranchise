#inserire nella root directory (quella in cui si trova la directory code e il file kubeconfig.yaml)
#ed eseguirlo con sh deploy.sh da tale directory
# $1 = docker username
# $2 = docker password
# $3 = docker email

export KUBECONFIG=./kubeconfig.yaml

kubectl create namespace integration
kubectl create namespace backend
kubectl create namespace frontend

kubectl label namespace integration istio-injection=enabled --overwrite
kubectl label namespace backend istio-injection=enabled --overwrite
kubectl label namespace frontend istio-injection=enabled --overwrite

#kubectl apply -f ./code/easyfranchise/deployment/k8s/db-secret.yaml
kubectl apply -f ./code/easyfranchise/deployment/k8s/db-secret-test.yaml

sudo docker login -u $1 -p $2

kubectl -n integration create secret docker-registry registry-secret --docker-server=https://index.docker.io/v1/  --docker-username=$1 --docker-password=$2 --docker-email=$3
kubectl -n backend create secret docker-registry registry-secret --docker-server=https://index.docker.io/v1/  --docker-username=$1 --docker-password=$2 --docker-email=$3
kubectl -n frontend create secret docker-registry registry-secret --docker-server=https://index.docker.io/v1/  --docker-username=$1 --docker-password=$2 --docker-email=$3

kubectl apply -f ./code/easyfranchise/deployment/k8s/btp-services.yaml

kubectl apply -n backend -f ./code/easyfranchise/deployment/k8s/backend-configmap.yaml
kubectl apply -n integration -f ./code/easyfranchise/deployment/k8s/backend-configmap.yaml

sudo docker build --no-cache=true --rm -t $1/sap-btp-trial-mission-test:approuter-0.1  -f ./code/easyfranchise/deployment/docker/Dockerfile-approuter .
sudo docker push $1/sap-btp-trial-mission-test:approuter-0.1

kubectl apply -f ./code/easyfranchise/deployment/k8s/approuter.yaml

sudo docker build --no-cache=true --rm -t $1/sap-btp-trial-mission-test:broker-0.1  -f ./code/easyfranchise/deployment/docker/Dockerfile-broker .
sudo docker push $1/sap-btp-trial-mission-test:broker-0.1

kubectl apply -f ./code/easyfranchise/deployment/k8s/broker.yaml

sudo docker build --no-cache=true --rm -t $1/sap-btp-trial-mission-test:bp-service-0.1  -f ./code/easyfranchise/deployment/docker/Dockerfile-bp-service .
sudo docker push $1/sap-btp-trial-mission-test:bp-service-0.1

kubectl apply -f ./code/easyfranchise/deployment/k8s/bp-service.yaml

sudo docker build --no-cache=true --rm -t $1/sap-btp-trial-mission-test:ef-service-0.1  -f ./code/easyfranchise/deployment/docker/Dockerfile-ef-service .
sudo docker push $1/sap-btp-trial-mission-test:ef-service-0.1

kubectl apply -f ./code/easyfranchise/deployment/k8s/ef-service.yaml

sudo docker build --no-cache=true --rm -t $1/sap-btp-trial-mission-test:db-service-0.1  -f ./code/easyfranchise/deployment/docker/Dockerfile-db-service .
sudo docker push $1/sap-btp-trial-mission-test:db-service-0.1

kubectl apply -f ./code/easyfranchise/deployment/k8s/db-service.yaml


sudo docker build --no-cache=true --rm -t $1/sap-btp-trial-mission-test:emailservice-0.1  -f ./code/easyfranchise/deployment/docker/Dockerfile-email-service .
sudo docker push $1/sap-btp-trial-mission-test:emailservice-0.1

kubectl apply -f ./code/easyfranchise/deployment/k8s/email-service.yaml

sudo docker build --no-cache=true --rm -t $1/sap-btp-trial-mission-test:ui-0.1  -f ./code/easyfranchise/deployment/docker/Dockerfile-ui .
sudo docker push $1/sap-btp-trial-mission-test:ui-0.1

kubectl apply -f ./code/easyfranchise/deployment/k8s/ui.yaml

#sudo docker image prune -a
