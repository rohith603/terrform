variable "project_id" {
  description = "leafy-respect-450512-p1"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-c"
}

variable "credentials_file" {
  description = "GCP Credentials File"
  type        = string
}
