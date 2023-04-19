provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../modules/vpc"
}

module "ec2" {
  subnet_id = module.vpc.public_subnet_ids[0]
  source = "../modules/ec2"
  depends_on = [
    module.vpc,
    module.rds
  ]
}

module "rds" {
  vpc_id = module.vpc.vpc_id
  source = "../modules/rds"
  depends_on = [
    module.vpc
  ]
}