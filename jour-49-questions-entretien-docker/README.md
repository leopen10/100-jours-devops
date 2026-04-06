# Jour 49 — Questions d'Entretien Docker 🎯

> ⏱️ Durée : 20 min | 📅 Date : 6 avril 2026 | ✅ Statut : Complété

---

## 🎯 Questions fondamentales

### Q1. C'est quoi Docker et pourquoi l'utiliser ?
```
Docker = Outil de conteneurisation qui empaquète une application
         et toutes ses dépendances dans un conteneur portable.

Avantages :
✅ "Works on my machine" → résolu !
✅ Déploiement rapide et reproductible
✅ Isolation des applications
✅ Léger vs VM (partage le kernel Linux)
✅ Scalable horizontalement
```

### Q2. Différence entre Image et Conteneur ?
```
Image     → Template immuable (recette de cuisine)
            Créé avec : docker build
            Stocké dans : Registry (ECR, Docker Hub)

Conteneur → Instance en cours d'exécution d'une image (plat cuisiné)
            Créé avec : docker run
            Éphémère par nature

Notre exemple Jour 42 :
  Image     : leonel-devops-ecr:v1 (133MB)
  Conteneur : leonel-flask (instance running)
```

### Q3. C'est quoi un Dockerfile ?
```dockerfile
FROM python:3.12-slim    # Image de base
WORKDIR /app             # Répertoire de travail
COPY requirements.txt .  # Copier les fichiers
RUN pip install -r requirements.txt  # Exécuter commandes
COPY . .                 # Copier le code
EXPOSE 5000              # Port exposé
CMD ["python", "app.py"] # Commande de démarrage
```

### Q4. Différence entre CMD et ENTRYPOINT ?
```
CMD         → Commande par défaut, remplaçable au docker run
ENTRYPOINT  → Commande fixe, CMD devient les arguments

Exemple :
  ENTRYPOINT ["python"]
  CMD ["app.py"]
  → docker run mon-image autre.py  # exécute: python autre.py

  CMD ["python", "app.py"]
  → docker run mon-image python autre.py  # remplace tout CMD
```

---

## 🔧 Questions Pratiques

### Q5. Comment réduire la taille d'une image Docker ?
```
✅ Utiliser une image de base légère (alpine, slim)
✅ Multi-Stage Build (séparer build et production)
✅ Combiner les RUN en une seule commande
✅ Utiliser .dockerignore
✅ Supprimer les caches

Notre preuve Jour 46 :
  Classique   python:3.12      → ~1GB
  Multi-Stage python:3.12-slim → 124MB (-88% !)
```

### Q6. Qu'est-ce que le Multi-Stage Build ?
```dockerfile
# Stage 1 : Build
FROM python:3.12-slim AS builder
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2 : Production (image finale légère)
FROM python:3.12-slim AS production
COPY --from=builder /root/.local /root/.local
COPY . .
CMD ["python", "app.py"]
```

### Q7. Différence entre Bind Mount et Volume ?
```
Volume     → Géré par Docker (/var/lib/docker/volumes/)
             ✅ Recommandé en production
             ✅ Portable entre conteneurs
             ✅ Sauvegarde facile

Bind Mount → Dossier local monté dans le conteneur
             ✅ Développement local
             ✅ Accès direct aux fichiers
             ❌ Dépend du chemin de la machine

Notre preuve Jour 47 :
  Volume    : docker run -v leonel-data:/app/data → "Données persistantes" ✅
  Bind Mount: docker run -v $(pwd)/dossier:/app/data → fichier local ✅
```

### Q8. Types de réseaux Docker ?
```
bridge  → Réseau par défaut entre conteneurs sur le même host
host    → Partage le réseau de la machine hôte (performances max)
none    → Aucun réseau (isolation totale)
overlay → Communication entre conteneurs sur différents hosts (Swarm)

Notre preuve Jour 48 :
  docker network create leonel-network
  conteneur-1 → 172.18.0.2/16
  conteneur-2 → 172.18.0.3/16
  Communication inter-conteneurs ✅
```

---

## 🚀 Questions Avancées

### Q9. Comment fonctionne Docker layer cache ?
```
Chaque instruction Dockerfile = 1 layer (couche)
Docker met en cache chaque layer

Optimisation :
  COPY requirements.txt .     ← Layer stable (peu change)
  RUN pip install             ← Mis en cache si requirements.txt inchangé
  COPY . .                    ← Layer qui change souvent (code)

→ Mettre les instructions qui changent souvent EN BAS du Dockerfile !
```

### Q10. Qu'est-ce que .dockerignore ?
```
Fichier qui exclut des fichiers du contexte de build (comme .gitignore)

Exemple .dockerignore :
  .git/
  __pycache__/
  *.pyc
  .env
  node_modules/
  terraform.tfstate

→ Réduit la taille du contexte de build
→ Évite de copier des secrets dans l'image !
```

### Q11. Comment déboguer un conteneur qui plante ?
```bash
# Voir les logs
docker logs <container_id> --tail 50

# Entrer dans le conteneur
docker exec -it <container_id> bash

# Inspecter le conteneur
docker inspect <container_id>

# Voir les stats en temps réel
docker stats <container_id>

# Lancer en mode interactif pour déboguer
docker run -it --entrypoint bash mon-image
```

### Q12. Différence entre docker stop et docker kill ?
```
docker stop  → Envoie SIGTERM (arrêt gracieux, 10s timeout)
               → Le processus peut finir ses tâches en cours

docker kill  → Envoie SIGKILL (arrêt immédiat, brutal)
               → Le processus est tué immédiatement
```

---

## ✅ Nos Preuves dans la Formation

```
Jour 42 : Image Flask poussée sur ECR → sha256:81f826...
Jour 43 : Conteneur Flask HTTP 200 - CPU 0.01% - RAM 24MB
Jour 44 : Conteneur Django HTTP 200 - RAM 18MB
Jour 45 : Django Invoice HTTP 302 - 130 static files - RAM 98MB
Jour 46 : Multi-Stage Build 124MB vs 1GB (-88%)
Jour 47 : Volume + Bind Mount données persistantes ✅
Jour 48 : Network Bridge custom 172.18.0.2-3 ✅
```

---

## ➡️ Prochain Jour

[Jour 50 — Docker Compose : Orchestrez vos Conteneurs Facilement](../jour-50-docker-compose/)
