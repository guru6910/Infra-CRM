provider "aws" {
    region = "us-west-1"
}

module "rds" {
    source = "./modules/rds"
}

module "eks" {
    source = "./modules/eks"
    project = "dyl"
    desired_nodes = 2
    max_nodes = 2
    min_nodes = 2
    node_instance_type = "t3.medium"
}

module "s3" {
    source = "./modules/s3"
}