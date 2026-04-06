# Jour 51 — Introduction à Kubernetes (K8s) : Pourquoi Docker ne suffit plus ? ☸️

> ⏱️ Durée : 20 min | 📅 Date : 6 avril 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi Docker ne suffit plus ?

```
Problèmes avec Docker seul en production :

❌ Scalabilité manuelle    → Lancer 100 conteneurs manuellement ?
❌ Pas de haute dispo      → Si le conteneur tombe, il reste tombé
❌ Pas de load balancing   → Docker ne répartit pas la charge
❌ Mises à jour complexes  → Rolling update = scripts manuels
❌ Monitoring limité       → Pas de health check automatique
❌ Multi-host difficile    → Docker Compose = un seul host

Solution : Kubernetes (K8s) !
```

---

## ☸️ C'est quoi Kubernetes ?

```
Kubernetes = Orchestrateur de conteneurs open source (Google, 2014)
             Nom tiré du grec = "Timonier" (pilote de navire)
             K8s = K + 8 lettres + s

Rôle :
✅ Déployer des conteneurs automatiquement
✅ Scaler horizontalement (ajouter des instances)
✅ Auto-healing (relancer les conteneurs qui tombent)
✅ Load balancing automatique
✅ Rolling updates (mises à jour sans downtime)
✅ Gestion des secrets et configurations
```

---

## 🏗️ Composants clés de Kubernetes

### Cluster
```
Cluster = Ensemble de machines (Nodes) gérées par Kubernetes

┌─────────────────────────────────────────────────────┐
│                    CLUSTER K8S                       │
│                                                      │
│  ┌──────────────────┐    ┌──────────────────────┐   │
│  │   Control Plane   │    │    Worker Nodes       │   │
│  │   (Master)        │    │                      │   │
│  │                   │    │  ┌────┐ ┌────┐ ┌────┐│   │
│  │  API Server       │    │  │Pod │ │Pod │ │Pod ││   │
│  │  Scheduler        │    │  └────┘ └────┘ └────┘│   │
│  │  etcd             │    │                      │   │
│  │  Controller Mgr   │    │  Node 1  Node 2      │   │
│  └──────────────────┘    └──────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

### Pod
```
Pod = Plus petite unité K8s = 1 ou plusieurs conteneurs
      Partage le réseau et le stockage

Exemple :
  Pod = { conteneur-nginx + conteneur-app }
  → Même IP, même localhost
  → Créé et détruit ensemble
```

### Node
```
Node = Machine (VM ou physique) qui héberge les Pods

Types :
  Master Node → Gère le cluster (Control Plane)
  Worker Node → Exécute les Pods (applications)
```

### ReplicaSet
```
ReplicaSet = Garantit N copies d'un Pod en permanence

Exemple :
  replicas: 3 → K8s maintient toujours 3 Pods identiques
  Si 1 Pod tombe → K8s en crée un nouveau automatiquement !
```

### Deployment
```
Deployment = Gère les ReplicaSets + Rolling Updates

Exemple :
  v1 → v2 progressivement (0 downtime)
  Rollback possible en 1 commande
```

### Service
```
Service = Point d'accès stable vers les Pods

Types :
  ClusterIP    → Accès interne au cluster uniquement
  NodePort     → Accès depuis l'extérieur via port
  LoadBalancer → Load Balancer cloud (AWS ALB)
  ExternalName → Alias DNS externe
```

### Ingress
```
Ingress = Routage HTTP/HTTPS vers les services

Exemple :
  mon-app.com/api  → Service API
  mon-app.com/web  → Service Web
  → Un seul point d'entrée pour tout !
```

---

## ⚖️ Docker vs Kubernetes

| Critère | Docker seul | Kubernetes |
|---------|------------|------------|
| **Scalabilité** | Manuelle | ✅ Automatique |
| **Haute dispo** | ❌ | ✅ Auto-healing |
| **Load Balancing** | ❌ | ✅ Intégré |
| **Rolling Update** | Scripts | ✅ Natif |
| **Multi-host** | Difficile | ✅ Natif |
| **Complexité** | Simple | Plus complexe |
| **Usage** | Dev/Test | Production |

---

## ☁️ Kubernetes en Cloud (Managé)

```
AWS    → EKS (Elastic Kubernetes Service)
GCP    → GKE (Google Kubernetes Engine)
Azure  → AKS (Azure Kubernetes Service)

Avantage : Control Plane géré par le cloud provider
           → Pas besoin de gérer les masters !
```

---

## 🔧 Commandes kubectl de base

```bash
# Voir les nodes du cluster
kubectl get nodes

# Voir les pods
kubectl get pods
kubectl get pods -n mon-namespace

# Créer une ressource
kubectl apply -f deployment.yml

# Voir les logs
kubectl logs <pod-name>

# Entrer dans un pod
kubectl exec -it <pod-name> -- bash

# Scaler
kubectl scale deployment mon-app --replicas=5

# Voir les services
kubectl get services

# Décrire une ressource
kubectl describe pod <pod-name>
```

---

## 📄 Premier Deployment YAML

```yaml
# deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: leonel-devops
spec:
  replicas: 3
  selector:
    matchLabels:
      app: leonel-devops
  template:
    metadata:
      labels:
        app: leonel-devops
    spec:
      containers:
      - name: app
        image: leonel-devops-ecr:v1
        ports:
        - containerPort: 5000
```

---

## ➡️ Prochain Jour

[Jour 52 — Architecture de Kubernetes : Maîtriser les Composants du Cluster](../jour-52-architecture-kubernetes/)
