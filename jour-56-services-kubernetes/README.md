# Jour 56 - Les Services Kubernetes : ClusterIP, NodePort, LoadBalancer

> Date : 6 avril 2026 | Statut : Completed avec preuve Killercoda K8s 1.35

## Services crees et testes
```
ClusterIP :
  leonel-clusterip  ClusterIP  10.100.69.7  80/TCP
  Acces interne uniquement

NodePort :
  leonel-nodeport  NodePort  10.106.125.49  80:32052/TCP
  Acces externe via port 32052

Test ClusterIP :
  curl http://10.100.69.7 → nginx OK
```

## Prochain Jour
Jour 57 - Deployer une App Flask sur Kubernetes
