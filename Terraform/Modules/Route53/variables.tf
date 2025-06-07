variable "nginx_lb_dns" {
  description = "DNS name of the NGINX Load Balancer"
}

variable "domain_name" {
  description = "Base domain name"
}

variable "jenkins_host" {
  description = "Jenkins host URL"
}

variable "argocd_host" {
  description = "ArgoCD host URL"
}

variable "prometheus_host" {
  description = "Prometheus host URL"
}

variable "grafana_host" {
  description = "Grafana host URL"
}

variable "sonarqube_host" {
  description = "SonarQube host URL"
}

variable "AppHost" {
  description = "App host URL"

}
