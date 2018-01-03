provider "aws" {}

terraform {
  backend "s3" {
    bucket = "mx-terraform"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "172.31.128.0/20"
}

module "assignment-service" {
  source = "./modules/assignment-service"
}

module "approval-service" {
  source = "./modules/approval-service"
}

module "profiling-service" {
  source = "./modules/profiling-service"
}

module "datareceiver" {
  source = "./modules/datareceiver"
}

module "loans-service" {
  source = "./modules/loans-service"
}

module "serverapi" {
  source = "./modules/serverapi"
}

module "payments-service" {
  source = "./modules/payments-service"
}

module "zendesk" {
  source = "./modules/zendesk"
}

module "customersupport" {
  source = "./modules/customersupport"
}

module "rds" {
  source = "./modules/database"
}
