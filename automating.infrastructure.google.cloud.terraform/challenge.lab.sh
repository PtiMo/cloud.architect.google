gcloud auth list

gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-b

export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get-value compute/region)
export ZONE=$(gcloud config get-value compute/zone)

touch main.tf
touch variables.tf
mkdir modules
mkdir modules/instances
touch modules/instances/instances.tf
touch modules/instances/outputs.tf
touch modules/instances/variables.tf
mkdir modules/storage
touch modules/storage/storage.tf
touch modules/storage/outputs.tf
touch modules/storage/variables.tf


gcloud storage buckets create gs://$PROJECT_ID --project=$PROJECT_ID --location=US

terraform init
terraform apply
terraform show

# COPY FILES CONTENT

terraform import module.instances.google_compute_instance.vm_instance_1 "qwiklabs-gcp-02-4c6fb763c716/us-east1-b/tf-instance-1"
terraform import module.instances.google_compute_instance.vm_instance_2 "qwiklabs-gcp-02-4c6fb763c716/us-east1-b/tf-instance-2"

terraform taint module.instances.google_compute_instance.vm_instance_3