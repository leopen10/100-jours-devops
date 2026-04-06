# Jour 57 - Deployer une App Flask sur Kubernetes

> Date : 6 avril 2026 | Statut : Completed avec preuve Killercoda K8s 1.35

## App deployee sur K8s
```
Deployment : leonel-flask (3 replicas nginx)
Service    : leonel-flask-svc NodePort 80:32642/TCP

ConfigMap  : leonel-config
  APP_NAME : LEONEL DEVOPS
  ENV      : production

Test HTTP :
  URL  : http://172.30.1.2:32642
  HTTP : 200 OK - nginx repond !
```

## Prochain Jour
Jour 58 - Introduction a Ingress dans Kubernetes
