student_04_bf7e431c11b3@cloudshell:~ (qwiklabs-gcp-04-a70447d5840b)$ history
    1  gcloud auth list
    2  gcloud config list project
    3  gcloud config set compute/zone us-central1-f
    4  gcloud services enable compute.googleapis.com
    5  gsutil mb gs://fancy-store-$DEVSHELL_PROJECT_ID
    6  git clone https://github.com/googlecodelabs/monolith-to-microservices.git
    7  cd ~/monolith-to-microservices
    8  ./setup.sh
    9  nvm install --lts
   10  cd microservices
   11  npm start
   12  gsutil cp ~/monolith-to-microservices/startup-script.sh gs://fancy-store-$DEVSHELL_PROJECT_ID
   13  cd ~
   14  rm -rf monolith-to-microservices/*/node_modules
   15  gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/
   16  gcloud compute instances create backend     --machine-type=n1-standard-1     --tags=backend    --metadata=startup-script-url=https://storage.googleapis.com/fancy-store-$DEVSHELL_PROJECT_ID/startup-script.sh
   17  cd ~/monolith-to-microservices/react-app
   18  npm install && npm run-script build
   19  cd ~
   20  rm -rf monolith-to-microservices/*/node_modules
   21  gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/
   22  gcloud compute instances create frontend     --machine-type=n1-standard-1     --tags=frontend     --metadata=startup-script-url=https://storage.googleapis.com/fancy-store-$DEVSHELL_PROJECT_ID/startup-script.sh
   23  gcloud compute firewall-rules create fw-fe     --allow tcp:8080     --target-tags=frontend
   24  gcloud compute firewall-rules create fw-be     --allow tcp:8081-8082     --target-tags=backend
   25  gcloud compute instances list
   26  watch -n 2 curl http://34.172.237.252:8080
   27  watch -n 2 curl http://34.172.237.252:8080
   28  watch -n 2 curl http://34.172.237.252:8080
   29  gcloud compute instances stop frontend
   30  gcloud compute instances stop backend
   31  gcloud compute instance-templates create fancy-fe     --source-instance=frontend
   32  gcloud compute instance-templates create fancy-be     --source-instance=backend
   33  gcloud compute instance-templates list
   34  gcloud compute instances delete backend
   35  gcloud compute instance-groups managed create fancy-fe-mig     --base-instance-name fancy-fe     --size 2     --template fancy-fe
   36  gcloud compute instance-groups managed create fancy-be-mig     --base-instance-name fancy-be     --size 2     --template fancy-be
   37  gcloud compute instance-groups set-named-ports fancy-fe-mig     --named-ports frontend:8080
   38  gcloud compute instance-groups set-named-ports fancy-be-mig     --named-ports orders:8081,products:8082
   39  gcloud compute health-checks create http fancy-fe-hc     --port 8080     --check-interval 30s     --healthy-threshold 1     --timeout 10s     --unhealthy-threshold 3
   40  gcloud compute health-checks create http fancy-be-hc     --port 8081     --request-path=/api/orders     --check-interval 30s     --healthy-threshold 1     --timeout 10s     --unhealthy-threshold 3
   41  gcloud compute firewall-rules create allow-health-check     --allow tcp:8080-8081     --source-ranges 130.211.0.0/22,35.191.0.0/16     --network default
   42  gcloud compute instance-groups managed update fancy-fe-mig     --health-check fancy-fe-hc     --initial-delay 300
   43  gcloud compute instance-groups managed update fancy-be-mig     --health-check fancy-be-hc     --initial-delay 300
   44  gcloud compute http-health-checks create fancy-fe-frontend-hc   --request-path /   --port 8080
   45  gcloud compute http-health-checks create fancy-be-orders-hc   --request-path /api/orders   --port 8081
   46  gcloud compute http-health-checks create fancy-be-products-hc   --request-path /api/products   --port 8082
   47  gcloud compute backend-services create fancy-fe-frontend   --http-health-checks fancy-fe-frontend-hc   --port-name frontend   --global
   48  gcloud compute backend-services create fancy-be-orders   --http-health-checks fancy-be-orders-hc   --port-name orders   --global
   49  gcloud compute backend-services create fancy-be-products   --http-health-checks fancy-be-products-hc   --port-name products   --global
   50  gcloud compute backend-services add-backend fancy-fe-frontend   --instance-group fancy-fe-mig   --instance-group-zone us-central1-f   --global
   51  gcloud compute backend-services add-backend fancy-be-orders   --instance-group fancy-be-mig   --instance-group-zone us-central1-f   --global
   52  gcloud compute backend-services add-backend fancy-be-products   --instance-group fancy-be-mig   --instance-group-zone us-central1-f   --global
   53  gcloud compute url-maps create fancy-map   --default-service fancy-fe-frontend
   54  gcloud compute url-maps add-path-matcher fancy-map    --default-service fancy-fe-frontend    --path-matcher-name orders    --path-rules "/api/orders=fancy-be-orders,/api/products=fancy-be-products"
   55  gcloud compute target-http-proxies create fancy-proxy   --url-map fancy-map
   56  gcloud compute forwarding-rules create fancy-http-rule   --global   --target-http-proxy fancy-proxy   --ports 80
   57  cd ~/monolith-to-microservices/react-app/
   58  gcloud compute forwarding-rules list --global
   59  cd ~/monolith-to-microservices/react-app
   60  npm install && npm run-script build
   61  cd ~
   62  rm -rf monolith-to-microservices/*/node_modules
   63  gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/
   64  gcloud compute instance-groups managed rolling-action replace fancy-fe-mig     --max-unavailable 100%
   65  watch -n 2 gcloud compute instance-groups list-instances fancy-fe-mig
   66  watch -n 2 gcloud compute backend-services get-health fancy-fe-frontend --global
   67  gcloud compute instance-groups managed set-autoscaling   fancy-fe-mig   --max-num-replicas 2   --target-load-balancing-utilization 0.60
   68  gcloud compute instance-groups managed set-autoscaling   fancy-be-mig   --max-num-replicas 2   --target-load-balancing-utilization 0.60
   69  gcloud compute backend-services update fancy-fe-frontend     --enable-cdn --global
   70  gcloud compute instances set-machine-type frontend --machine-type custom-4-3840
   71  gcloud compute instance-templates create fancy-fe-new     --source-instance=frontend     --source-instance-zone=us-central1-f
   72  gcloud compute instance-groups managed rolling-action start-update fancy-fe-mig     --version template=fancy-fe-new
   73  watch -n 2 gcloud compute instance-groups managed list-instances fancy-fe-mig
   74  gcloud compute instance describe fancy-fe-7xss | grep machineType
   75  gcloud compute instances describe fancy-fe-7xss | grep machineType
   76  cd ~/monolith-to-microservices/react-app/src/pages/Home
   77  mv index.js.new index.js
   78  cat ~/monolith-to-microservices/react-app/src/pages/Home/index.js
   79  cd ~/monolith-to-microservices/react-app
   80  npm install && npm run-script build
   81  cd ~
   82  rm -rf monolith-to-microservices/*/node_modules
   83  gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/
   84  gcloud compute instance-groups managed rolling-action replace fancy-fe-mig     --max-unavailable=100%
   85  watch -n 2 gcloud compute instance-groups list-instances fancy-fe-mig
   86  watch -n 2 gcloud compute backend-services get-health fancy-fe-frontend --global
   87  nge to use a larger machine type and push th
   88  gcloud compute forwarding-rules list --global
   89  gcloud compute instance-groups list-instances fancy-fe-mig
   90  gcloud compute ssh fancy-fe-mccj (then in the instance : sudo supervisorctl stop nodeapp; sudo killall node)
   91  watch -n 2 gcloud compute operations list --filter='operationType~compute.instances.repair.*'
   92  history   