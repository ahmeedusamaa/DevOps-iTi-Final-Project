variable "prefix" {
  description = "Prefix for all resources"
}

variable "eks_name" {
  description = "Name Of The EKS Cluster"
}

variable "eks_version" {
  description = "Version Of The EKS Cluster"
}

variable "ng_role_arn" {
  description = "Node Group IAM role ARN"
}

variable "ng_worker_node_policy_attachment" {
  description = "Worker Node IAM Policy Attachment"
}

variable "ng_cni_policy_attachment" {
  description = "CNI Policy Attachment"
}

variable "ng_ecr_policy_attachment" {
  description = "ECR Read-Only Policy Attachment"
}

variable "Public_Subnets_ID" {
  description = "IDs Of The Public Subnets"
}

variable "Private_Subnets_ID" {
  description = "IDs Of The Private Subnets"
}

variable "Cluster_Name" {
  description = "Name Of The EKS Cluster"
}

variable "node_group_name" {
  description = "Node Group Name"
}

variable "Capacity_Type" {
  description = "Node Group Capacity Type"
}

variable "instance_type" {
  description = "Node Group Instance Type"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair to use for SSH access"
}

variable "bastion_sg_id" {
  description = "Security group that allows SSH (usually the bastion host SG)"
}

variable "zone1" {
  description = "Availability Zone 1"
}

variable "zone2" {
  description = "Availability Zone 2"
}

locals {
  private_subnets_1a_1b = [
    for i, az in [var.zone1, var.zone2] : var.Private_Subnets_ID[i]
  ]
}
