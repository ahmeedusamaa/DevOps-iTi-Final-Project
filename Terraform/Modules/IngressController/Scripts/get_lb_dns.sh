#!/bin/bash
lb_dns=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "{\"lb_dns\": \"$lb_dns\"}"
