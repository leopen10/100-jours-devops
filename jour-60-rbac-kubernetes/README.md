# Jour 60 - RBAC dans Kubernetes : Controle Acces Roles Securite

> Date : 6 avril 2026 | Statut : Completed avec preuve Killercoda K8s 1.35

## RBAC configure et teste
```
ServiceAccount : leonel-sa

Role : leonel-pod-reader
  Resources : pods
  Verbs     : get, list, watch

RoleBinding : leonel-pod-reader-binding
  leonel-sa → Role/leonel-pod-reader

Tests permissions :
  can-i get pods        → yes (autorise)
  can-i delete pods     → no  (interdit)
  can-i get deployments → no  (interdit)
```

## Prochain Jour
Jour 61 - ConfigMap et Secret dans Kubernetes
