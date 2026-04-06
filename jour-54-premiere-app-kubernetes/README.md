# Jour 54 - Deployer ta Premiere App sur Kubernetes

> Date : 6 avril 2026 | Statut : Completed avec preuve sur Killercoda K8s 1.35

## Cluster Kubernetes reel - Killercoda
```
Nodes :
  controlplane  Ready  control-plane  v1.35.1
  node01        Ready  worker         v1.35.1

Deployment leonel-app :
  Replicas : 3 → scale 5
  Pods Running sur node01 + controlplane
  IPs : 192.168.1.253 | 192.168.1.22 | 192.168.0.63

Service NodePort :
  leonel-app  10.96.154.79  80:31165/TCP
  Endpoints : 3 IPs actives

Rolling Update :
  nginx → nginx:alpine → rolled out successfully
  Revision 1 → 2 → rollback vers 1
  5/5 pods Running apres rollback
```

## Prochain Jour
Jour 55 - Kubernetes Deployment et ReplicaSet
