student_04_4a6ef187eca6@cloudshell:~ (qwiklabs-gcp-04-68aeb7fea24b)$ history
    1  gcloud auth list
    2  gcloud config list project
    3  mkdir ~/randomgen && cd $_
    4  vim main.py
    5  vim requirement.txt
    6  gcloud functions deploy randomgen      --runtime python37      --trigger-http      --allow-unauthenticated
    7  gcloud functions describe randomgen    --format="(httpsTrigger.url)"
    8  gcloud functions describe randomgen
    9  cd ..
   10  mkdir ~/multiply && cd $_
   11  vim main.py
   12  vim requirement.txt
   13  gcloud functions deploy multiply   --runtime python37   --trigger-http   --allow-unauthenticated
   14  curl $(gcloud functions describe multiply \
   --format='value(httpsTrigger.url)')   -X POST   -H "content-type: application/json"   -d '{"input": 5}'
   15  gcloud functions describe multiply   --format='value(httpsTrigger.url)'
   16  gcloud functions describe randomgen   --format='value(httpsTrigger.url)'
   17  cd ..
   18  vim workflow.yaml
   19  gcloud beta workflows deploy workflow --source=workflow.yaml
   20  gcloud beta workflows executions describe-last
   21  curl https://api.mathjs.org/v4/?'expr=log(56)' -w "\n"
   22  gcloud beta workflows delete workflow
   23  gcloud beta workflows deploy workflow   --source=workflow.yaml
   24  mkdir ~/floor && cd $_
   25  vim app.py
   26  vim Dockerfile
   27  export SERVICE_NAME=floor
   28  gcloud builds submit   --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/${SERVICE_NAME}
   29  gcloud run deploy ${SERVICE_NAME}      --image gcr.io/${GOOGLE_CLOUD_PROJECT}/${SERVICE_NAME}      --platform managed      --no-allow-unauthenticated      --region us-west1      --max-instances=3
   30  export SERVICE_ACCOUNT=workflows-sa
   31  gcloud iam service-accounts create ${SERVICE_ACCOUNT}
   32  gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT}   --member "serviceAccount:${SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com"   --role "roles/run.invoker"
   33  gcloud  beta workflows deploy workflow --source=workflow.yaml --service-account=${SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
   34  cd ..
   35  gcloud  beta workflows deploy workflow --source=workflow.yaml --service-account=${SERVICE_ACCOUNT}@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
   36  gcloud beta workflows execute workflow
   37  gcloud beta workflows executions describe-last
   38  history