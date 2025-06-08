variable "vpc_cidr_block" {
  description = "VPC CIDR block"
}

variable "Public_Subnets_count" {
  description = "Public Subnets Count"
}

variable "Private_Subnets_count" {
  description = "Private Subnets Count"
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

variable "region" {
  description = "AWS region"
}

variable "eks_image_id" {
  description = "EKS Optimized AMI"
}

variable "node_group_label" {
  description = "Label for the Node Group"
}

variable "my_ip" {
  description = "My address CIDR"
}

variable "secret-store_name" {
  description = "Name of the ClusterSecretStore"
}

variable "service_account_name" {
  description = "Kubernetes Service Account name used for IRSA"
}

variable "service_account_namespace" {
  description = "Namespace of the Service Account"
}

variable "email" {
  description = "Email address for Let's Encrypt notifications"
}

variable "domain_name" {
  description = "Base domain name"
}

variable "Account_ID" {
  description = "AWS Account ID"
}

variable "FrontEnd_ECR_repository_name" {
  description = "FrontEnd ECR Repo Mame"
}

variable "BackEnd_ECR_repository_name" {
  description = "BackEnd ECR Repo Mame"
}

variable "app_name" {
  description = "Application name"
}

variable "port" {
  description = "App port"
  type        = number
}

variable "mysql_host" {
  type        = string
  description = "MySQL host"
}

variable "mysql_port" {
  type        = number
  description = "MySQL port"
}

variable "mysql_user" {
  type = string
}

variable "mysql_password" {
  type      = string
  sensitive = true
}

variable "mysql_database" {
  type = string
}

variable "redis_host" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "redis_password" {
  type      = string
  sensitive = true
}

variable "jenkins_admin_username" {
  type = string
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
}

variable "grafana_admin_user" {
  type = string
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "App_Chart_Repo" {
  description = "Git repository for the application chart"
}

variable "ssh_private_key" {
  description = "SSH private key for accessing the Git repository"
  type        = string
  sensitive   = true
}
