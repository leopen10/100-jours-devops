# Jour 55 - Kubernetes Deployment et ReplicaSet

> Date : 6 avril 2026 | Statut : Completed avec preuve Killercoda K8s 1.35

## ReplicaSet - Auto-healing prouve
```
kubectl create rs leonel-rs --replicas=3

Auto-healing :
  kubectl delete pod leonel-rs-jqsxq
  → K8s recrée leonel-rs-rw4kx automatiquement !

Scale 3 → 5 :
  Replicas: 5 current / 5 desired
  Pods Status: 3 Running / 2 Waiting
  Image: nginx:alpine
```

## Prochain Jour
Jour 56 - Les Services Kubernetes : ClusterIP, NodePort, LoadBalancer
