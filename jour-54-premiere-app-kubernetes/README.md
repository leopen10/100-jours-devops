# Jour 54 - Deployer ta Premiere App sur Kubernetes

> Date : 6 avril 2026 | Statut : Completed avec preuve

## Manifests generes avec kubectl
```bash
kubectl create deployment leonel-app --image=leonel-devops-ecr:v1 --replicas=3 --dry-run=client -o yaml
```

## Deployment genere
- name: leonel-app
- replicas: 3
- image: leonel-devops-ecr:v1

## Service NodePort
- port: 80 → targetPort: 5000 → nodePort: 30080

## Prochain Jour
Jour 55 - Kubernetes Deployment et ReplicaSet
