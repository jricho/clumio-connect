# Instantiate the AWS provider
provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      "Vendor" = "Clumio"
    }
  }
}
terraform {
  backend "s3" {
    bucket         = "jr-tfstate"
    key            = "~/code/clumio-connect/terraform.tfstate"
    region         = "us-east-2"  
  }
}
# Retrieve the effective AWS account ID and region
data aws_caller_identity current {}
data aws_region current {}

# Register a new Clumio connection for the effective AWS account ID and region
resource "clumio_aws_connection" "connection" {
  account_native_id = data.aws_caller_identity.current.account_id
  aws_region        = data.aws_region.current.name
  description       = "My Clumio Connection"
}
# Install the Clumio AWS template onto the registered connection
module "clumio_protect" {
  providers = {
    clumio = clumio
    aws    = aws
  }
  source                = "clumio-code/aws-template/clumio"
  clumio_token          = clumio_aws_connection.connection.token
  role_external_id      = clumio_aws_connection.connection.role_external_id
  aws_account_id        = clumio_aws_connection.connection.account_native_id
  aws_region            = clumio_aws_connection.connection.aws_region
  clumio_aws_account_id = clumio_aws_connection.connection.clumio_aws_account_id

  # Enable protection of all data sources.
  is_ebs_enabled      = false
  is_rds_enabled      = false
  is_dynamodb_enabled = false
  is_s3_enabled       = true
}

