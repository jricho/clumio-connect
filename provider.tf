terraform {
  required_providers {
    clumio = {
      source  = "clumio-code/clumio"
      version = "~>0.11.0"
    }
    aws = {}
  }
}

# Instantiate the Clumio provider
provider "clumio" {
  clumio_api_token    = var.clumio_api_token
  clumio_api_base_url = var.clumio_api_base_url
}

variable "clumio_api_token" {
  description = "Clumio API token"
  type        = string
  sensitive   = true
}

variable "clumio_api_base_url" {
  description = "Clumio API base URL"
  type        = string
  sensitive   = true
}