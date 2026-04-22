resource "aws_key_pair" "eks" {
  key_name   = "expense-eks"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYKXdraPFv8U1gyd0ELNNqy+ZntsC+4csub3kSsh2N2dGysRoH/C0lhIzWEBWrwjl+BeqUv9Yk92hKjfJ578RMjoXrx4eZzbuC9KY7wGExmNuiRWBQSJRPITyZ+4CphODtQraanlXhFYIi/uwjKIPiT+edknxTNA72GVexOwEOP5GMiGprvB2s0Zw7cNEnmhrV22+IZFbJFbPUQ2FPqi79Llg+7jqoFATOebWv2wXstZR2/4VEfYlx9pS02OH5+IdKiBIvaeZMnJSWsBHykXTqBZ1EefIZI9RLphkqmIl9cWatMQl378CG+yJq7+LCKDnRZmYVDJHkwdI91wtei6cuv6mzeTyXkMjNycA1Ef5GAM7OblgI7w0usXImnwuHlInQYFzkY2z1jwhzBl16x+ONwgWRULy/XejsgI8rn9rzEB3tyyx5rBSE4/MB9NIms1W5rOWqZaM53co/1t+GIvxTn7wLkn02MH8o7MB22wE1rG03Pju9YvVqV0zzU4iVsqmROq9UsvQcmudX57UkCYSxmfpA9ebBjMkNi7TCkxjgoZcG5OWexGExnUwPm1uke7MkTQ+pYANDH9LvdNXRb4i6IS84QKEpXDDGi30xi/e45J5PblSZ3K01MJE8KKwzVVtLc8Iwodf66OwX+5pbWhdaZpnwkogiz1FgsAg0yNJ3Fw== srinivasreddy@Srinivass-MacBook-Air.local"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name
  cluster_version = "1.32" # later we upgrade 1.32
  create_node_security_group = false
  create_cluster_security_group = false
  cluster_security_group_id = local.eks_control_plane_sg_id
  node_security_group_id = local.eks_node_sg_id

  #bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    metrics-server = {}
  }

  # Optional
  cluster_endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small", "t3a.small"]
  }

  eks_managed_node_groups = {
    blue = {
      //Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.small"]
      key_name = aws_key_pair.eks.key_name

      min_size     = 2
      max_size     = 10
      desired_size = 3
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEKSLoadBalancingPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
    } 

    # green = {
    #   # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
    #   #ami_type       = "AL2_x86_64"
    #   instance_types = ["t3.small"]
    #   key_name = aws_key_pair.eks.key_name

    #   min_size     = 2
    #   max_size     = 10
    #   desired_size = 3
    #   iam_role_additional_policies = {
    #     AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    #     AmazonEKSLoadBalancingPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    #   }
    # }
  }

  tags = merge(
    var.common_tags,
    {
        Name = local.name
    }
  )
}