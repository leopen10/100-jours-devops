# Jour 45 - Deployer Django avec Docker sur AWS EC2

> Date : 5 avril 2026 | Statut : Completed avec preuve

## LEONEL INVOICE SYSTEM dockerise sur EC2
```
Image    : leonel-invoice-docker:v4
Container: leonel-invoice-docker (c70a42afea03)
Port     : 0.0.0.0:8000->8000/tcp

Build reussi :
  Migrations  : Apply all migrations OK
  Staticfiles : 130 static files copied

Test HTTP : curl http://localhost:8000 → HTTP 302

Stats:
  CPU : 7.32%
  RAM : 98.49MiB / 911.5MiB (10.81%)
```

## Prochain Jour
Jour 46 - Docker Multi-Stage Build et Images Distroless
