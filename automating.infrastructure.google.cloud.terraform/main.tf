terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }

  backend "gcs" {
    bucket  = "qwiklabs-gcp-02-d3b030e5c152"
    prefix  = "terraform/state"
  }
}

provider "google" {
  version = "3.5.0"

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "instances" {
  source = "./modules/instances"
}

module "storage" {
  source = "./modules/storage"
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "2.5.0"

    project_id   = var.project_id
    network_name = "terraform-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_region         = var.zone
        },
        {
            subnet_name           = "subnet-02"
            subnet_region         = var.zone
        }
    ]
}

resource "google_compute_firewall" "default" {
  name    = "tf-firewall"
  network = module.vpc.network_name

  allow {
    protocol = "tcp"
    ports    = "80"
  }

  source_range = "0.0.0.0/0"
}
