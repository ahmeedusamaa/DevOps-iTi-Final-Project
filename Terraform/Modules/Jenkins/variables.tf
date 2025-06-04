variable "jenkins_irsa_role_arn" {
  description = "ARN of the Jenkins IRSA role"
}

variable "kaniko_irsa_role" {
  description = "values for kaniko IRSA role"
}

variable "kaniko_irsa_role_name" {
  description = "values for kaniko IRSA role"
}

variable "kaniko_ecr_policy_arn" {
  description = "ARN of the Kaniko ECR policy"
}

variable "kaniko_irsa_role_arn" {
  description = "values for kaniko IRSA role ARN"
}

variable "ingress_hosts" {
  description = "values for ingress hosts"
  type        = map(string)
}
