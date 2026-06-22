module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "security_group" {
  source = "./modules/security_group"

  project_name = var.project_name

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  project_name = var.project_name
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.security_group.ec2_sg_id
  instance_type     = var.instance_type
}

module "rds" {
  source = "./modules/rds"
  project_name = var.project_name
  subnet_ids        = [module.vpc.private_subnet_id]
  security_group_id = module.security_group.rds_sg_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
