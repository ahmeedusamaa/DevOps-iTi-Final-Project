output "PrivateNG" {
  value = aws_eks_node_group.PrivateNG
}


output "eks_core_dns" {
  value = aws_eks_addon.coredns
}
