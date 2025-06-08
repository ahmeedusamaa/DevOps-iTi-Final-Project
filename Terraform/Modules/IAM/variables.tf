variable "prefix" {
  description = "Prefix for all resources"
}

variable "eks_name" {
  description = "Name Of The EKS Cluster"
}

variable "oidc_issuer" {
  description = "value of the OIDC issuer URL"
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
}
