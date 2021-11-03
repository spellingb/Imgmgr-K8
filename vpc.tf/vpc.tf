module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  version                 = "3.7.0"
  #source                  = "./modules/vpc"

  name                    = "${var.namespace}-${var.environment}-VPC"
  cidr                    = "${var.CiderBlock}.0.0/16"
  azs                     = local.availability_zones
  private_subnets         = local.priv_networks
  public_subnets          = local.pub_networks
  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true  

  
  public_subnet_tags  = {
    Name                                              = "${var.namespace}-Public"
    Environment                                       = var.environment
    "kubernetes.io/cluster/${var.namespace}-${var.environment}"  = "shared"
    "kubernetes.io/role/elb"                          = "1"  
  }
  private_subnet_tags = {
      Name = "${var.namespace}-Private"
      Environment = var.environment
      "kubernetes.io/cluster/${var.namespace}-${var.environment}"  = "shared"
      "kubernetes.io/role/internal-elb"                 = "1"
    }
  tags  = {
    Terraform = "true"
    Environment = var.environment
  }
  vpc_tags = {
    Name = "${var.namespace}-${var.environment}-VPC"
    Environment = var.environment
  }
}
