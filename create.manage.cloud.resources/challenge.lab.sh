# Task 0. Configure your environment
gcloud auth list

gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-b

gcloud config get-value project

export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get-value compute/region)
export ZONE=$(gcloud config get-value compute/zone)


# Task 1. Create a project jumphost instance
gcloud compute instances create nucleus-jumphost-235 \
--zone=$ZONE \
--tags=jumphost \
--machine-type=f1-micro \
--image-family=debian-11 \
--image-project=debian-cloud

# Task 2. Create a Kubernetes service cluster.

## Create a GKE cluster:
gcloud container clusters create --machine-type=n1-standard-1 --zone=$ZONE nucleus-gke1

## Authenticate with the cluster:
gcloud container clusters get-credentials nucleus-gke1

## Create a new Deployment:
kubectl create deployment nucleus-hello1 --image=gcr.io/google-samples/hello-app:2.0

## Create a Kubernetes Service:
kubectl expose deployment nucleus-hello1 --type=LoadBalancer --port 8082



# Task 3. Set up an HTTP load balancer.

## Create an instance template:
gcloud compute instance-templates create nucleus-http-lb-template \
   --region=$REGION \
   --network=default \
   --subnet=default \
   --tags=nucleus-http-lb \
   --machine-type=n1-standard-1 \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='cat << EOF > startup.sh
        #! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
        EOF'

## Create a target pool:


## Create a managed instance group:
gcloud compute instance-groups managed create nucleus-http-lb-group \
   --template=nucleus-http-lb-template --size=2 --zone=$ZONE

## Create a firewall rule named as Firewall rule to allow traffic (80/tcp):
gcloud compute firewall-rules create grant-tcp-rule-113 \
  --network=default \
  --action=allow \
  --direction=ingress \
  --target-tags=nucleus-http-lb \
  --rules=tcp:80

## Create a health check:
gcloud compute health-checks create http nucleus-http-basic-check \
  --port 80

## Create a backend service, and attach the managed instance group with named port (http:80):
gcloud compute backend-services create nucleus-http-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=nucleus-http-basic-check \
  --global
gcloud compute backend-services add-backend nucleus-http-backend-service \
  --instance-group=nucleus-http-lb-group \
  --instance-group-zone=$ZONE \
  --global

## Create a URL map, and target the HTTP proxy to route requests to your URL map:
gcloud compute url-maps create nucleus-http-map \
    --default-service nucleus-http-backend-service

gcloud compute target-http-proxies create nucleus-http-lb-proxy \
    --url-map nucleus-http-map

## Create a forwarding rule:
gcloud compute addresses create nucleus-http-lb-ipv4-1 \
  --ip-version=IPV4 \
  --global
gcloud compute addresses describe nucleus-http-lb-ipv4-1 \
  --format="get(address)" \
  --global
gcloud compute forwarding-rules create nucleus-http-content-rule \
    --address=nucleus-http-lb-ipv4-1 \
    --global \
    --target-http-proxy=nucleus-http-lb-proxy \
    --ports=80
