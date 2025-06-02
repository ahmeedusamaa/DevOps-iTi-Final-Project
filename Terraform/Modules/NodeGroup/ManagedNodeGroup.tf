resource "aws_eks_node_group" "PrivateNG" {
  cluster_name    = var.Cluster_Name
  version         = var.eks_version
  node_group_name = var.node_group_name
  capacity_type   = var.Capacity_Type
  instance_types  = [var.instance_type]
  node_role_arn   = var.ng_role_arn

  subnet_ids = var.Private_Subnets_ID
  # subnet_ids = local.private_subnets_1a_1b


  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 4
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [var.bastion_sg_id]
  }


  labels = {
    type = "PrivateNG"
  }

  depends_on = [
    var.ng_worker_node_policy_attachment,
    var.ng_cni_policy_attachment,
    var.ng_ecr_policy_attachment
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
