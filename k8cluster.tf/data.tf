data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-VPC"]
  }
}

data "aws_subnet_ids" "private_sub_id" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.namespace}-Private"
  }
}

data "aws_subnet_ids" "public_sub_id" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.namespace}-Public"
  }
}

data "aws_subnet" "private_sub" {
  for_each = data.aws_subnet_ids.private_sub_id.ids
  id       = each.value
}


data "aws_iam_policy_document" "cluster-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "node-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_caller_identity" "current" {}
