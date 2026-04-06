# Jour 53 — Comprendre Kubernetes Cluster : Nodes, Pods, Services ☸️

> ⏱️ Durée : 25 min | 📅 Date : 6 avril 2026 | ✅ Statut : Complété

---

## 🎯 Le Cluster Kubernetes en pratique

```
Un Cluster K8s = ensemble de machines qui travaillent ensemble
pour exécuter des applications conteneurisées de façon fiable.

Notre objectif :
  Déployer une app Flask sur K8s avec 3 replicas
  Exposer via un Service LoadBalancer
  Auto-healing si un Pod tombe
```

---

## 📦 Les Pods en détail

### Qu'est-ce qu'un Pod ?
```yaml
# Un Pod = 1 ou plusieurs conteneurs qui partagent :
#   → Le même réseau (localhost entre conteneurs)
#   → Le même stockage (volumes partagés)
#   → Le même cycle de vie

apiVersion: v1
kind: Pod
metadata:
  name: leonel-pod
  labels:
    app: leonel
    version: v1
spec:
  containers:
  - name: flask-app
    image: leonel-devops-ecr:v1
    ports:
    - containerPort: 5000
    env:
    - name: ENV
      value: production
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

### Cycle de vie d'un Pod
```
Pending    → Pod créé, en attente de scheduling
Running    → Pod sur un Node, au moins 1 conteneur running
Succeeded  → Tous les conteneurs ont terminé avec succès
Failed     → Au moins 1 conteneur a échoué
Unknown    → État inconnu (Node inaccessible)
```

---

## 🔄 ReplicaSet et Deployment

### ReplicaSet
```yaml
# Garantit toujours N replicas d'un Pod
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: leonel-rs
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
      - name: flask-app
        image: leonel-devops-ecr:v1
        ports:
        - containerPort: 5000
```

### Deployment (recommandé en prod)
```yaml
# Gère les ReplicaSets + Rolling Updates
apiVersion: apps/v1
kind: Deployment
metadata:
  name: leonel-deployment
  namespace: default
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1          # Max pods en plus pendant update
      maxUnavailable: 0    # 0 downtime !
  selector:
    matchLabels:
      app: leonel
  template:
    metadata:
      labels:
        app: leonel
    spec:
      containers:
      - name: flask-app
        image: leonel-devops-ecr:v1
        ports:
        - containerPort: 5000
        readinessProbe:
          httpGet:
            path: /
            port: 5000
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /
            port: 5000
          initialDelaySeconds: 15
          periodSeconds: 20
```

---

## 🌐 Les Services Kubernetes

### ClusterIP (défaut)
```yaml
# Accès interne au cluster uniquement
apiVersion: v1
kind: Service
metadata:
  name: leonel-clusterip
spec:
  selector:
    app: leonel
  ports:
  - port: 80
    targetPort: 5000
  type: ClusterIP
```

### NodePort
```yaml
# Accès depuis l'extérieur via port du Node
apiVersion: v1
kind: Service
metadata:
  name: leonel-nodeport
spec:
  selector:
    app: leonel
  ports:
  - port: 80
    targetPort: 5000
    nodePort: 30080    # Port accessible sur chaque Node
  type: NodePort
```

### LoadBalancer (AWS ELB)
```yaml
# Crée un Load Balancer cloud automatiquement
apiVersion: v1
kind: Service
metadata:
  name: leonel-lb
spec:
  selector:
    app: leonel
  ports:
  - port: 80
    targetPort: 5000
  type: LoadBalancer
# → AWS crée automatiquement un ELB !
```

---

## 🏷️ Labels et Selectors

```yaml
# Labels = étiquettes sur les ressources
metadata:
  labels:
    app: leonel
    env: production
    version: v1
    tier: frontend

# Selectors = filtres pour trouver les ressources
spec:
  selector:
    matchLabels:
      app: leonel
      env: production
```

```bash
# Filtrer par label
kubectl get pods -l app=leonel
kubectl get pods -l env=production,tier=frontend
```

---

## 🔧 Namespaces

```bash
# Isolation logique des ressources dans le cluster
kubectl get namespaces

# Namespaces par défaut :
#   default      → Ressources sans namespace spécifié
#   kube-system  → Composants K8s (API server, etcd...)
#   kube-public  → Ressources accessibles publiquement

# Créer un namespace
kubectl create namespace leonel-devops

# Déployer dans un namespace
kubectl apply -f deployment.yml -n leonel-devops

# Voir les pods dans un namespace
kubectl get pods -n leonel-devops
```

---

## ✅ Commandes Pratiques

```bash
# Pods
kubectl get pods
kubectl get pods -o wide          # Avec IPs et Nodes
kubectl describe pod <name>       # Détails complets
kubectl delete pod <name>         # Supprimer (ReplicaSet recrée !)

# Deployments
kubectl apply -f deployment.yml
kubectl get deployments
kubectl rollout status deployment/leonel-deployment
kubectl rollout undo deployment/leonel-deployment  # Rollback !

# Services
kubectl get services
kubectl describe service leonel-lb

# Scaler
kubectl scale deployment leonel-deployment --replicas=5

# Port forward (tester localement)
kubectl port-forward pod/leonel-pod 8080:5000
```

---

## ➡️ Prochain Jour

[Jour 54 — Déploie ta Première App sur Kubernetes : Pods, Services, Exposition](../jour-54-premiere-app-kubernetes/)
