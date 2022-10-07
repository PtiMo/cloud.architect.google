student_02_4c5e9882b30b@cloudshell:~/sample-app (qwiklabs-gcp-01-b72f2f9a61e9)$ history
    1  gcloud config set compute/zone us-east1-d
    2  gcloud container clusters create spinnaker-tutorial     --machine-type=n1-standard-2
    3  gcloud iam service-accounts create spinnaker-account     --display-name spinnaker-account
    4  export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')
    5  export PROJECT=$(gcloud info --format='value(config.project)')
    6  gcloud projects add-iam-policy-binding $PROJECT     --role roles/storage.admin     --member serviceAccount:$SA_EMAIL
    7  gcloud iam service-accounts keys create spinnaker-sa.json      --iam-account $SA_EMAIL
    8  ls
    9  gcloud pubsub topics create projects/$PROJECT/topics/gcr
   10  gcloud pubsub subscriptions create gcr-triggers     --topic projects/${PROJECT}/topics/gcr
   11  export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')
   12  gcloud beta pubsub subscriptions add-iam-policy-binding gcr-triggers     --role roles/pubsub.subscriber --member serviceAccount:$SA_EMAIL
   13  kubectl create clusterrolebinding user-admin-binding     --clusterrole=cluster-admin --user=$(gcloud config get-value account)
   14  kubectl create clusterrolebinding --clusterrole=cluster-admin     --serviceaccount=default:default spinnaker-admin
   15  helm repo add stable https://charts.helm.sh/stable
   16  helm repo update
   17  export PROJECT=$(gcloud info \
    --format='value(config.project)')
   18  export BUCKET=$PROJECT-spinnaker-config
   19  gsutil mb -c regional -l us-east1 gs://$BUCKET
   20  export SA_JSON=$(cat spinnaker-sa.json)
   21  export PROJECT=$(gcloud info --format='value(config.project)')
   22  export BUCKET=$PROJECT-spinnaker-config
   23  cat > spinnaker-config.yaml <<EOF
gcs:
  enabled: true
  bucket: $BUCKET
  project: $PROJECT
  jsonKey: '$SA_JSON'
dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '$SA_JSON'
  email: 1234@5678.com
# Disable minio as the default storage backend
minio:
  enabled: false
# Configure Spinnaker to enable GCP services
halyard:
  spinnakerVersion: 1.19.4
  image:
    repository: us-docker.pkg.dev/spinnaker-community/docker/halyard
    tag: 1.32.0
    pullSecrets: []
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers           --subscription-name gcr-triggers           --json-path /opt/gcs/key.json           --project $PROJECT           --message-format GCR
EOF

   24  helm install -n default cd stable/spinnaker -f spinnaker-config.yaml            --version 2.0.0-rc9 --timeout 10m0s --wait
   25  export DECK_POD=$(kubectl get pods --namespace default -l "cluster=spin-deck" \
    -o jsonpath="{.items[0].metadata.name}")
   26  kubectl port-forward --namespace default $DECK_POD 8080:9000 >> /dev/null &
   27  gsutil -m cp -r gs://spls/gsp114/sample-app.tar .
   28  mkdir sample-app
   29  tar xvf sample-app.tar -C ./sample-app
   30  cd sample-app
   31  git config --global user.email "$(gcloud config get-value core/account)"
   32  git config --global user.name "Lab User"
   33  git init
   34  git add .
   35  git commit -m "Initial commit"
   36  gcloud source repos create sample-app
   37  export PROJECT=$(gcloud info --format='value(config.project)')
   38  git remote add origin https://source.developers.google.com/p/$PROJECT/r/sample-app
   39  git push origin master
   40  export PROJECT=$(gcloud info --format='value(config.project)')
   41  gsutil mb -l us-east1 gs://$PROJECT-kubernetes-manifests
   42  gsutil versioning set on gs://$PROJECT-kubernetes-manifests
   43  sed -i s/PROJECT/$PROJECT/g k8s/deployments/*
   44  git commit -a -m "Set project ID"
   45  git tag v1.0.0
   46  git push --tags
   47  curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/1.14.0/linux/amd64/spin
   48  chmod +x spin
   49  ./spin application save --application-name sample                         --owner-email "$(gcloud config get-value core/account)"                         --cloud-providers kubernetes                         --gate-endpoint http://localhost:8080/gate
   50  export PROJECT=$(gcloud info --format='value(config.project)')
   51  sed s/PROJECT/$PROJECT/g spinnaker/pipeline-deploy.json > pipeline.json
   52  ./spin pipeline save --gate-endpoint http://localhost:8080/gate -f pipeline.json
   53  sed -i 's/orange/blue/g' cmd/gke-info/common-service.go
   54  git commit -a -m "Change color to blue"
   55  git tag v1.0.1
   56  git push --tags
   57  history