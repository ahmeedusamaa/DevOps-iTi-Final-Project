
variable "ingress_hosts" {
  description = "values for ingress hosts"
  type        = map(string)
}

variable "region" {
  description = "AWS region"
}

variable "Account_ID" {
  description = "AWS Account ID"
}

variable "argou_irsa_role_arn" {
  description = "values for Argo Image Updater IRSA role"
}

variable "FrontEnd_ECR_repository_name" {
  description = "FrontEnd ECR Repo Mame"
}

variable "BackEnd_ECR_repository_name" {
  description = "BackEnd ECR Repo Mame"
}

variable "App_Chart_Repo" {
  description = "Git repository for the application chart"
}

variable "ssh_private_key" {
  description = "SSH private key for accessing the Git repository"
  type        = string
  sensitive   = true
}
