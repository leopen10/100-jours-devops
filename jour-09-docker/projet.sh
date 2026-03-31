#!/bin/bash
# ============================================================
# Jour 09 - Docker Introduction
# Projet : Dockeriser l'API Flask du Jour 8
# ============================================================

set -e

echo "=========================================="
echo " JOUR 09 - Docker Introduction"
echo "=========================================="

# ----- INSTALLATION DOCKER -----
echo ""
echo ">>> ETAPE 1 : Installation Docker..."
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
echo "Docker installe ✓"

# Ajouter ubuntu au groupe docker
sudo usermod -aG docker ubuntu

# ----- CREER LE PROJET -----
echo ""
echo ">>> ETAPE 2 : Creer le projet Flask a dockeriser..."
mkdir -p ~/flaskapp-docker
cd ~/flaskapp-docker

# app.py
cat > app.py << 'EOF'
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route("/hello", methods=["GET"])
def hello():
    return jsonify({
        "message": "Hello from Docker!",
        "container": os.environ.get("HOSTNAME", "unknown"),
        "version": "2.0.0"
    })

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy", "service": "flaskapp-docker"})

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
EOF

# requirements.txt
cat > requirements.txt << 'EOF'
Flask==2.3.2
EOF

# Dockerfile
cat > Dockerfile << 'EOF'
# Image de base legere
FROM python:3.10-slim

# Metadonnees
LABEL maintainer="Leonel-Magloire PENGOU MBA <leonelpengou10@gmail.com>"
LABEL version="1.0"
LABEL description="API Flask DevOps - Jour 9"

# Repertoire de travail
WORKDIR /app

# Copier et installer les dependances en premier (cache Docker)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code
COPY . .

# Exposer le port
EXPOSE 5000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:5000/health || exit 1

# Commande de demarrage
CMD ["python", "app.py"]
EOF

# .dockerignore
cat > .dockerignore << 'EOF'
__pycache__/
*.pyc
*.pyo
.git/
.env
venv/
*.log
EOF

echo "Fichiers du projet crees ✓"
ls -la

# ----- BUILD -----
echo ""
echo ">>> ETAPE 3 : Build de l'image Docker..."
sudo docker build -t leopen10/flaskapp-devops:v1 .
echo "Image buildee ✓"

# Voir les images
sudo docker images | grep flaskapp

# ----- RUN -----
echo ""
echo ">>> ETAPE 4 : Lancer le conteneur..."
sudo docker run -d \
    --name flaskapp-jour9 \
    -p 5001:5000 \
    leopen10/flaskapp-devops:v1

sleep 2
echo "Conteneur lance ✓"

# ----- TEST -----
echo ""
echo ">>> ETAPE 5 : Tester l'API..."
curl http://localhost:5001/hello
curl http://localhost:5001/health

# ----- LOGS -----
echo ""
echo ">>> ETAPE 6 : Voir les logs..."
sudo docker logs flaskapp-jour9

# ----- INSPECTER -----
echo ""
echo ">>> ETAPE 7 : Inspecter le conteneur..."
sudo docker ps
sudo docker inspect flaskapp-jour9 | grep -E "IPAddress|Status|Image"

# ----- NETTOYAGE -----
echo ""
echo ">>> ETAPE 8 : Nettoyage..."
sudo docker stop flaskapp-jour9
sudo docker rm flaskapp-jour9
echo "Conteneur arrete et supprime ✓"

echo ""
echo "=========================================="
echo " JOUR 09 TERMINE !"
echo " Image : leopen10/flaskapp-devops:v1"
echo " Concepts maitrises :"
echo "   ✅ Installation Docker"
echo "   ✅ Dockerfile professionnel"
echo "   ✅ docker build"
echo "   ✅ docker run (-d, -p, --name)"
echo "   ✅ docker logs"
echo "   ✅ docker inspect"
echo "   ✅ HEALTHCHECK"
echo "   ✅ .dockerignore"
echo "=========================================="
