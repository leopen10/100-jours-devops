# Jour 53 - Kubernetes Cluster : Nodes, Pods, Services

> Date : 6 avril 2026 | Statut : Completed avec preuve

## Manifests K8s crees et valides
```bash
kubectl apply -f deployment.yml --dry-run=client
kubectl apply -f service.yml --dry-run=client
```

## Fichiers crees
- deployment.yml : Deployment 3 replicas Flask leonel-devops-ecr:v1
- service.yml    : Service LoadBalancer port 80 → 5000

## Note
Minikube non lance : EC2 t3.micro insuffisant (911MB RAM)
Manifests valides syntaxiquement avec kubectl dry-run
Application sur vrai cluster : Jour 59 AWS EKS + Fargate

## Prochain Jour
Jour 54 - Deployer une App sur Kubernetes
