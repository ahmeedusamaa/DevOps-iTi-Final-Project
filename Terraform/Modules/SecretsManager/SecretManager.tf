resource "aws_secretsmanager_secret" "app_secrets" {
  name                    = "app-secrets"
  description             = "Flattened secrets for MySQL, Redis, Jenkins, ArgoCD, Grafana, SonarQube"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_secrets_version" {
  secret_id = aws_secretsmanager_secret.app_secrets.id

  secret_string = jsonencode({
    PORT           = var.port
    MYSQL_HOST     = var.mysql_host
    MYSQL_PORT     = var.mysql_port
    MYSQL_USER     = var.mysql_user
    MYSQL_PASSWORD = var.mysql_password
    MYSQL_DATABASE = var.mysql_database

    REDIS_HOST     = var.redis_host
    REDIS_PORT     = var.redis_port
    REDIS_PASSWORD = var.redis_password

    JENKINS_ADMIN_USERNAME = var.jenkins_admin_username
    JENKINS_ADMIN_PASSWORD = var.jenkins_admin_password

    GRAFANA_ADMIN_USER     = var.grafana_admin_user
    GRAFANA_ADMIN_PASSWORD = var.grafana_admin_password
  })
}
