gcloud auth list

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

# COPY FILES CONTENT

terraform import module.instances.google_compute_instance.vm_instance_1 "qwiklabs-gcp-02-d3b030e5c152/us-central1-a/tf-instance-1"
terraform import module.instances.google_compute_instance.vm_instance_2 "qwiklabs-gcp-02-d3b030e5c152/us-central1-a/tf-instance-2"
terraform show -no-color > ./modules/instances/instances.tf
