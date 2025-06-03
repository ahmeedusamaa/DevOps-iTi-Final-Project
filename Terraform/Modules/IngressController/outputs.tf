output "nginx_lb_dns" {
  value = data.external.nginx_lb_dns.result.lb_dns
}
