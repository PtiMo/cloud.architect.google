variable "region" {
  description = "GCP Region."
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "GCP zone."
  type        = string
  default     = "us-east1-b"
}

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "qwiklabs-gcp-02-4c6fb763c716"
}
