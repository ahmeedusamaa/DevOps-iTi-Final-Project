data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.jenkins_host
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_dns]
}

resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.argocd_host
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_dns]
}

resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.prometheus_host
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_dns]
}

resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.grafana_host
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_dns]
}


resource "aws_route53_record" "sonarqube" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.sonarqube_host
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_dns]
}


resource "aws_route53_record" "AppHost" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.AppHost
  type    = "CNAME"
  ttl     = 300
  records = [var.nginx_lb_dns]
}
