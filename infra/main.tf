terraform {
  required_version = "=1.8.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# IAM
module "iam" {
  source             = "./modules/iam"
  app_name           = var.app_name
  kinesis_stream_arn = module.kinesis.kinesis_stream_arn
}

# ECR
module "ecr" {
  source     = "./modules/ecr"
  image_name = var.image_name
  app_name   = var.app_name
}

# BASH
module "bash" {
  source     = "./modules/bash"
  region     = var.region
  image_name = var.image_name
}


# network
module "network" {
  source   = "./modules/network"
  app_name = var.app_name
  api_port = var.api_port
}

# ECS
module "ecs" {
  source                      = "./modules/ecs"
  app_name                    = var.app_name
  sg_ecs_id                   = module.network.sg_ecs_id
  subnet_private_subnet_1a_id = module.network.subnet_private_subnet_1a_id
  subnet_public_subnet_1a_id  = module.network.subnet_public_subnet_1a_id
  ecs_iam_role                = module.iam.ecs_iam_role
  api_repository_url          = module.ecr.api_repository_url
  api_port                    = var.api_port
  kinesis_stream_name         = module.kinesis.kinesis_stream_name
}

module "kinesis" {
  source   = "./modules/kinesis"
  app_name = var.app_name
}

module "lambda" {
  source             = "./modules/lambda"
  app_name           = var.app_name
  lambda_iam_role    = module.iam.lambda_iam_role
  kinesis_stream_arn = module.kinesis.kinesis_stream_arn
  s3_bucket_name     = module.s3.s3_bucket_name
}

module "s3" {
  source   = "./modules/s3"
  app_name = var.app_name
  region   = var.region

}
