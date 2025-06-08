output "eks_role_arn" {
  value = aws_iam_role.eks.arn
}

output "Control_Plane_Policy_attatchment" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy
}

output "ng_role" {
  value = aws_iam_role.nodes
}

output "ng_role_arn" {
  value = aws_iam_role.nodes.arn
}

output "ng_worker_node_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_worker_node_policy
}

output "ng_cni_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_cni_policy
}

output "ng_ecr_policy_attachment" {
  value = aws_iam_role_policy_attachment.ec2_container_registry_read_only
}

output "ng-instance-profile" {
  value = aws_iam_instance_profile.nodes.arn
}

output "ng_instance_profile_name" {
  value = aws_iam_instance_profile.nodes.name
}
output "jenkins_irsa_role_arn" {
  value = aws_iam_role.jenkins_irsa.arn
}

output "ebs_csi_irsa_role_arn" {
  value = aws_iam_role.ebs_csi_irsa.arn
}

output "eso_irsa_role_arn" {
  value = aws_iam_role.eso_irsa.arn
}

output "kaniko_irsa_role" {
  value = aws_iam_role.kaniko_irsa_role
}

output "kaniko_irsa_role_name" {
  value = aws_iam_role.kaniko_irsa_role.name
}

output "kaniko_ecr_policy_arn" {
  value = aws_iam_policy.kaniko_ecr_policy.arn
}

output "kaniko_irsa_role_arn" {
  value = aws_iam_role.kaniko_irsa_role.arn
}

output "argou_irsa_role" {
  value = aws_iam_role.argoiu_irsa.arn
}
