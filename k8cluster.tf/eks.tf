module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.21"
  subnets                         = data.aws_subnet_ids.private_sub_id.ids
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id = data.aws_vpc.vpc.id
  cluster_security_group_id = aws_security_group.cluster.id

  node_groups = {
    first = {
      name_prefix             = "${var.namespace}-${var.environment}-"
      desired_capacity        = var.desired_capacity
      max_capacity            = var.max_capacity
      min_capacity            = var.min_capacity
      capacity_type           = "ON_DEMAND"
      force_update_version    = true
      iam_role_arn            = aws_iam_role.node.arn
      launch_template_version = "$Latest"
      update_default_version	= true
      instance_types          = [var.instance_type]
      key_name                = "${var.region}-EC2-Default-Key"
      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
      worker_additional_security_group_ids = [aws_security_group.node.id]
    }
  }
  map_roles = [
      {
      rolearn  = local.role
      username = local.rolename
      groups   = ["system:masters"]
    }
  ]
  map_users = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = local.username
      groups   = ["system:masters"]
    }
  ]

  write_kubeconfig       = true
  kubeconfig_name        = "config"
  kubeconfig_output_path = "../.kube/${var.environment}/"
}

