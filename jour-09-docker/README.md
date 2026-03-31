# Jour 09 — Docker : Introduction et Premiers Conteneurs 🐳

> ⏱️ Durée : ~45 min | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🎯 Qu'est-ce qu'un Conteneur ?

Un conteneur est une **unité standard de logiciel** qui regroupe :
- Le code de l'application
- Toutes ses dépendances
- Les bibliothèques système nécessaires
- Les paramètres de configuration

➡️ L'application s'exécute de manière identique dans **n'importe quel environnement**.

---

## ⚖️ Conteneurs vs Machines Virtuelles

| Critère | Conteneur | Machine Virtuelle |
|---------|-----------|------------------|
| **Poids** | ~22 Mo (Ubuntu) | ~2,3 Go (Ubuntu) |
| **Démarrage** | Secondes | Minutes |
| **Isolation** | Noyau partagé | OS complet isolé |
| **Portabilité** | Excellent | Limitée |
| **Ressources** | Léger | Lourd |

**Pourquoi les conteneurs sont légers ?**
Ils partagent le **noyau Linux de l'hôte** via des namespaces et cgroups — pas besoin d'OS complet.

---

## 🐳 Docker — Architecture

```
┌─────────────────────────────────────┐
│           Docker Client (CLI)        │
│  docker build | run | push | pull   │
└──────────────┬──────────────────────┘
               │ API
┌──────────────▼──────────────────────┐
│         Docker Daemon (dockerd)      │  ← Le cerveau de Docker
│   Gère images, conteneurs, volumes  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│          Docker Registry             │
│   Docker Hub / Quay.io / ECR        │
└─────────────────────────────────────┘
```

### Cycle de vie Docker
```
Dockerfile → docker build → Image → docker run → Conteneur
                                  ↓
                            docker push → Registry (DockerHub)
```

---

## ⚙️ Installation Docker sur Ubuntu EC2

```bash
# Mettre à jour et installer Docker
sudo apt update
sudo apt install docker.io -y

# Démarrer et activer Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

# Ajouter l'utilisateur au groupe docker (évite sudo)
sudo usermod -aG docker ubuntu

# Se déconnecter et reconnecter pour appliquer
exit
```

---

## 🚀 Commandes Essentielles Docker

### Images
```bash
docker images                          # Lister les images locales
docker pull ubuntu                     # Télécharger une image
docker rmi ubuntu                      # Supprimer une image
docker build -t mon-app:v1 .           # Construire une image
docker push username/mon-app:v1        # Pousser sur DockerHub
```

### Conteneurs
```bash
docker run hello-world                 # Tester l'installation
docker run -it ubuntu bash             # Mode interactif
docker run -d -p 80:5000 mon-app      # Mode détaché + port mapping
docker ps                              # Conteneurs actifs
docker ps -a                           # Tous les conteneurs
docker stop <id>                       # Arrêter un conteneur
docker rm <id>                         # Supprimer un conteneur
docker logs <id>                       # Voir les logs
docker exec -it <id> bash             # Entrer dans un conteneur
```

### Nettoyage
```bash
docker system prune                    # Nettoyer tout ce qui est inutilisé
docker volume prune                    # Nettoyer les volumes
```

---

## 📄 Dockerfile — Créer une Image

```dockerfile
# Image de base
FROM python:3.10-slim

# Répertoire de travail
WORKDIR /app

# Copier les dépendances
COPY requirements.txt .

# Installer les dépendances
RUN pip install -r requirements.txt

# Copier le code
COPY . .

# Exposer le port
EXPOSE 5000

# Commande de démarrage
CMD ["python", "app.py"]
```

### Instructions Dockerfile essentielles
| Instruction | Description |
|-------------|-------------|
| `FROM` | Image de base |
| `WORKDIR` | Répertoire de travail |
| `COPY` | Copier des fichiers |
| `RUN` | Exécuter une commande |
| `ENV` | Variable d'environnement |
| `EXPOSE` | Port à exposer |
| `CMD` | Commande par défaut |
| `ENTRYPOINT` | Point d'entrée du conteneur |

---

## 🏋️ Projet Pratique — Dockeriser Flask

Voir [`projet/`](./projet/) — Dockerisation complète de l'API Flask du Jour 8.

---

## ➡️ Prochain Jour

[Jour 10 — Docker Avancé & Docker Compose](../jour-10-docker-compose/)
