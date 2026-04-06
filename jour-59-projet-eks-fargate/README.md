# Jour 59 — Projet AWS EKS avec Fargate et Ingress ALB ☸️

> ⏱️ Durée : 1h | 📅 Date : 6 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Déployer une application sur AWS EKS (Elastic Kubernetes Service) avec :
- **Fargate** : Nodes serverless (pas de EC2 à gérer)
- **ALB Ingress** : Application Load Balancer automatique
- **kubectl** : Gestion du cluster depuis l'EC2

---

## 🏗️ Architecture EKS + Fargate

```
Internet
    ↓
ALB (Application Load Balancer)
    ↓
Ingress Controller (AWS Load Balancer Controller)
    ↓
┌─────────────────────────────────────┐
│           AWS EKS CLUSTER            │
│                                      │
│  Fargate Profile                     │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │  Pod 1 │ │  Pod 2 │ │  Pod 3 │   │
│  │(Fargate)│ │(Fargate)│ │(Fargate)│  │
│  └────────┘ └────────┘ └────────┘   │
└─────────────────────────────────────┘
```

---

## ⚙️ Création du Cluster EKS

```bash
# Installer eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Créer le cluster EKS avec Fargate
eksctl create cluster \
    --name leonel-eks-cluster \
    --region us-east-1 \
    --fargate \
    --version 1.29

# Configurer kubectl
aws eks update-kubeconfig \
    --region us-east-1 \
    --name leonel-eks-cluster

# Vérifier
kubectl get nodes
```

---

## 🚀 Déployer l'Application

```yaml
# deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: leonel-app
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: leonel-app
  template:
    metadata:
      labels:
        app: leonel-app
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: leonel-service
  namespace: default
spec:
  selector:
    app: leonel-app
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

---

## 🌐 Ingress avec ALB

```yaml
# ingress.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: leonel-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: leonel-service
            port:
              number: 80
```

```bash
# Appliquer
kubectl apply -f deployment.yml
kubectl apply -f ingress.yml

# Voir l'URL de l'ALB
kubectl get ingress leonel-ingress
# ADDRESS → URL publique de l'ALB !
```

---

## ✅ Notre Pratique — Ingress sur Killercoda (Jour 58)

```
Cluster K8s 1.35 sur Killercoda :

Nginx Ingress Controller installé :
  pod/ingress-nginx-controller-f86fd6d96-8wffg → condition met

Ingress : leonel-ingress
  Host  : leonel.devops.local
  /app1 → app1-svc:80
  /app2 → app2-svc:80

Event : Normal Sync - Scheduled for sync ✅

→ Même concept que AWS EKS ALB Ingress !
  Killercoda = Nginx Ingress Controller
  AWS EKS    = AWS Load Balancer Controller (ALB)
```

---

## 💰 Coût EKS

```
EKS Control Plane : 0.10$/heure = ~72$/mois
Fargate            : 0.04048$/vCPU/heure + 0.004445$/GB/heure
                     → ~5$/mois pour 2 pods légers

Total estimé pour dev : ~77$/mois
→ Supprimer le cluster après usage !

eksctl delete cluster --name leonel-eks-cluster --region us-east-1
```

---

## 🔗 Différence EKS vs Killercoda

| Critère | Killercoda | AWS EKS |
|---------|-----------|---------|
| **Coût** | Gratuit | ~0.10$/h |
| **Nodes** | VM virtuelles | EC2 ou Fargate |
| **Ingress** | Nginx Controller | AWS ALB |
| **Persistance** | 4h session | Permanent |
| **Usage** | Apprentissage | Production |

---

## ➡️ Prochain Jour

[Jour 60 — RBAC dans Kubernetes : Contrôle d'Accès](../jour-60-rbac-kubernetes/)
