# Jour 52 — Architecture de Kubernetes : Maîtriser les Composants du Cluster K8s ☸️

> ⏱️ Durée : 21 min | 📅 Date : 6 avril 2026 | ✅ Statut : Complété

---

## 🏗️ Architecture Complète d'un Cluster Kubernetes

```
┌──────────────────────────────────────────────────────────────────┐
│                        CLUSTER KUBERNETES                         │
│                                                                    │
│  ┌─────────────────────────────────────────┐                      │
│  │           CONTROL PLANE (Master)         │                      │
│  │                                          │                      │
│  │  ┌──────────┐  ┌──────────┐  ┌───────┐  │                      │
│  │  │API Server│  │Scheduler │  │  etcd │  │                      │
│  │  └──────────┘  └──────────┘  └───────┘  │                      │
│  │  ┌──────────────────────────────────┐   │                      │
│  │  │     Controller Manager           │   │                      │
│  │  └──────────────────────────────────┘   │                      │
│  └─────────────────────────────────────────┘                      │
│                                                                    │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐   │
│  │   WORKER NODE 1  │  │  WORKER NODE 2  │  │  WORKER NODE 3  │   │
│  │                  │  │                 │  │                 │   │
│  │  ┌────┐ ┌────┐   │  │  ┌────┐ ┌────┐ │  │  ┌────┐ ┌────┐ │   │
│  │  │Pod │ │Pod │   │  │  │Pod │ │Pod │ │  │  │Pod │ │Pod │ │   │
│  │  └────┘ └────┘   │  │  └────┘ └────┘ │  │  └────┘ └────┘ │   │
│  │  Kubelet          │  │  Kubelet        │  │  Kubelet        │   │
│  │  Kube-proxy       │  │  Kube-proxy     │  │  Kube-proxy     │   │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🧠 Control Plane (Master Node)

### 1. API Server
```
Rôle    : Point d'entrée unique pour toutes les requêtes K8s
Usage   : kubectl → API Server → autres composants
Port    : 6443 (HTTPS)
Exemple : kubectl apply -f deployment.yml → API Server valide et stocke
```

### 2. etcd
```
Rôle    : Base de données clé-valeur distribuée
Usage   : Stocke TOUT l'état du cluster
          Nodes, Pods, ConfigMaps, Secrets...
Important: Si etcd tombe → cluster inutilisable !
Backup  : Sauvegarder etcd = sauvegarder le cluster
```

### 3. Scheduler
```
Rôle    : Décide sur quel Node placer chaque Pod
Critères: Resources disponibles (CPU, RAM)
          Labels et affinités
          Taints et tolerations
Exemple : "Ce Pod a besoin de 2 CPU → Node 2 a 4 CPU libre → Place ici"
```

### 4. Controller Manager
```
Rôle    : Boucle de contrôle qui maintient l'état désiré
Exemples:
  ReplicaSet Controller → Maintient N replicas
  Node Controller       → Détecte les nodes tombés
  Deployment Controller → Gère les rolling updates
  Service Controller    → Gère les load balancers
```

---

## 👷 Worker Node

### 1. Kubelet
```
Rôle    : Agent K8s sur chaque Worker Node
Usage   : Communique avec l'API Server
          Lance et surveille les Pods
          Rapporte l'état des Pods au Control Plane
```

### 2. Kube-proxy
```
Rôle    : Gestion du réseau sur chaque Node
Usage   : Maintient les règles réseau (iptables)
          Load balancing entre Pods
          Implémente les Services K8s
```

### 3. Container Runtime
```
Rôle    : Exécute les conteneurs
Options : containerd (défaut), Docker, CRI-O
```

---

## 📦 Objets Kubernetes Essentiels

### Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: leonel-pod
spec:
  containers:
  - name: app
    image: leonel-devops-ecr:v1
    ports:
    - containerPort: 5000
```

### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: leonel-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: leonel
  template:
    metadata:
      labels:
        app: leonel
    spec:
      containers:
      - name: app
        image: leonel-devops-ecr:v1
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

### Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: leonel-service
spec:
  selector:
    app: leonel
  ports:
  - port: 80
    targetPort: 5000
  type: LoadBalancer
```

---

## 🔄 Flux de création d'un Pod

```
1. kubectl apply -f deployment.yml
      ↓
2. API Server reçoit la requête → stocke dans etcd
      ↓
3. Scheduler voit le nouveau Pod → choisit Node 2
      ↓
4. API Server informe Kubelet du Node 2
      ↓
5. Kubelet demande au Container Runtime de lancer le Pod
      ↓
6. Pod = Running ✅
      ↓
7. Controller Manager surveille → si Pod tombe → recrée !
```

---

## ☁️ Kubernetes Managé en Production

```
AWS EKS  :
  Control Plane géré par AWS
  Worker Nodes = EC2 t3.medium (2 CPU, 4GB RAM min)
  Notre formation Jour 59 : EKS + Fargate + ALB Ingress

GCP GKE  :
  Control Plane gratuit
  Autopilot mode (pas de node management)

Azure AKS:
  Control Plane gratuit
  Intégration Azure AD
```

---

## ✅ Commandes Architecture

```bash
# Voir tous les composants du Control Plane
kubectl get pods -n kube-system

# Voir les nodes et leurs rôles
kubectl get nodes
kubectl describe node <node-name>

# Voir l'état de etcd
kubectl get pods -n kube-system | grep etcd

# Voir les events du cluster
kubectl get events --sort-by='.lastTimestamp'
```

---

## ➡️ Prochain Jour

[Jour 53 — Kubernetes Cluster : Nodes, Pods, Services](../jour-53-kubernetes-cluster/)
