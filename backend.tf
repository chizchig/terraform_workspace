terraform {
  backend "remote" {
    organization = "the_hub"
    workspaces {
      name = "terraform_workspace"
    }
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.34.0"
    }
  }
}