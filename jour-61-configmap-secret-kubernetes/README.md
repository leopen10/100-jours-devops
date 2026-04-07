# Jour 61 - ConfigMap et Secret dans Kubernetes

> Date : 7 avril 2026 | Statut : Completed avec preuve Killercoda K8s 1.35

## ConfigMap cree et teste
```
kubectl create configmap leonel-config

Data :
  APP_NAME : LEONEL DEVOPS
  ENV      : production
  PORT     : 8000
```

## Secret cree et teste
```
kubectl create secret generic leonel-secret

Type : Opaque
  DB_PASSWORD : 15 bytes (chiffre)
  API_KEY     : 21 bytes (chiffre)
```

## Pod avec variables injectees
```
Pod leonel-pod cree avec :
  APP_NAME   → depuis ConfigMap leonel-config
  DB_PASSWORD → depuis Secret leonel-secret
```

## Prochain Jour
Jour 62 - Persistent Volumes et Persistent Volume Claims
