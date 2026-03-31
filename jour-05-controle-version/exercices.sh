#!/bin/bash
# ============================================================
# Jour 05 - Introduction au Contrôle de Version (Git)
# Projet : Initialiser et gérer un repo Git complet
# ============================================================

echo "=========================================="
echo " JOUR 05 - Controle de Version avec Git"
echo "=========================================="

# ----- CONFIGURATION GIT -----
echo ""
echo ">>> ETAPE 1 : Configuration Git"
git config --global user.name "Leonel PENGOU"
git config --global user.email "leonelpengou10@gmail.com"
git config --global init.defaultBranch main
git config --list | grep user
echo "Git configure ✓"

# ----- CREER UN PROJET -----
echo ""
echo ">>> ETAPE 2 : Creer un projet DevOps"
mkdir -p ~/projet-devops-git
cd ~/projet-devops-git

# Initialiser Git
git init
echo "Repo Git initialise ✓"

# ----- PREMIER COMMIT -----
echo ""
echo ">>> ETAPE 3 : Premier commit"

# Creer des fichiers
cat > README.md << 'EOF'
# Projet DevOps - Jour 5

Application web deployee sur AWS EC2 avec Nginx.

## Technologies
- Linux Ubuntu 24.04
- Nginx
- Git

## Deploiement
```bash
./deploy.sh
```
EOF

cat > app.py << 'EOF'
# Application DevOps - Version 1.0
def hello_devops():
    return "Hello from DevOps Journey!"

if __name__ == "__main__":
    print(hello_devops())
    print("Version: 1.0.0")
EOF

cat > .gitignore << 'EOF'
# Fichiers a ignorer
*.log
*.tmp
__pycache__/
.env
*.pem
node_modules/
EOF

git add .
git status
git commit -m "feat: initial commit - projet devops jour 5"
echo "Premier commit cree ✓"

# ----- HISTORIQUE -----
echo ""
echo ">>> ETAPE 4 : Voir l'historique"
git log --oneline
git log --pretty=format:"%h - %an, %ar : %s"

# ----- BRANCHE FEATURE -----
echo ""
echo ">>> ETAPE 5 : Creer une branche feature"
git branch feature/monitoring
git checkout feature/monitoring
echo "Branche feature/monitoring creee ✓"

# Ajouter une fonctionnalite
cat > monitoring.sh << 'EOF'
#!/bin/bash
# Script de monitoring - Feature branch
echo "=== Monitoring Systeme ==="
echo "CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')%"
echo "Memoire: $(free -h | awk '/Mem:/ {print $3"/"$2}')"
echo "Disque: $(df -h / | awk 'NR==2 {print $3"/"$2}')"
echo "Nginx: $(systemctl is-active nginx 2>/dev/null || echo 'non installe')"
EOF

chmod +x monitoring.sh
git add monitoring.sh
git commit -m "feat: add monitoring script"
echo "Feature commit cree ✓"

# ----- MERGE -----
echo ""
echo ">>> ETAPE 6 : Merger la feature dans main"
git checkout main
git merge feature/monitoring
echo "Merge effectue ✓"

# ----- DIFF ET LOG FINAL -----
echo ""
echo ">>> ETAPE 7 : Historique final"
git log --oneline --graph --all
echo ""
echo "Fichiers dans le projet :"
ls -la

# ----- COMMANDES UTILES -----
echo ""
echo ">>> COMMANDES GIT UTILES"
echo "git diff HEAD~1        : Voir le dernier changement"
git diff HEAD~1 --stat

echo ""
echo "=========================================="
echo " PROJET GIT TERMINE !"
echo " Repo: ~/projet-devops-git"
echo " Commits: $(git log --oneline | wc -l)"
echo " Branches: $(git branch | wc -l)"
echo "=========================================="
