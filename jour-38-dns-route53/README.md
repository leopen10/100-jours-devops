# Jour 38 - DNS et AWS Route 53

> Date : 5 avril 2026 | Statut : Completed avec preuve

## Tests DNS pratiques depuis EC2
```
dig google.com A        → 172.253.115.113 (6 IPs)
curl ifconfig.me        → 44.222.105.23 (notre IP)
curl http://44.222.105.23 → HTTP 302 en 0.004621s
dig -x 44.222.105.23    → ec2-44-222-105-23.compute-1.amazonaws.com
dig s3 bucket           → s3-w.us-east-1.amazonaws.com
dig gmail.com MX        → gmail-smtp-in.l.google.com (priorite 5)
```

## Prochain Jour
Jour 39 - Projet AWS Production : VPC, NAT Gateway, ALB, Auto Scaling
