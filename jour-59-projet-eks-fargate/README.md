# Jour 59 - Projet AWS EKS avec Fargate et Ingress ALB

> Date : 6 avril 2026 | Statut : Completed avec preuve

## Outils installes
```
eksctl v0.225.0 installe sur EC2
kubectl v1.35.3 installe sur EC2
```

## Manifests EKS crees
- deployment.yml : 2 replicas nginx sur Fargate
- ingress.yml    : ALB internet-facing + target-type ip

## Commande creation cluster EKS
```bash
eksctl create cluster --name leonel-eks-cluster --region us-east-1 --fargate
aws eks update-kubeconfig --region us-east-1 --name leonel-eks-cluster
```

## Note
Cluster non lance : cout EKS ~0.10$/h + Fargate
Ingress pratique sur Killercoda Jour 58 (meme concept)

## Prochain Jour
Jour 60 - RBAC dans Kubernetes
