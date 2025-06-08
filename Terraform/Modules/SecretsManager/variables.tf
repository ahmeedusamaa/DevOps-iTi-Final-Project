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
