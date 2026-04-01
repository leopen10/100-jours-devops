#!/bin/bash
# ============================================================
# Jour 07 - Stratégies de Branches Git et Questions d'Entretien
# Projet : Workflow professionnel avec toutes les stratégies
# ============================================================

echo "=========================================="
echo " JOUR 07 - Strategies de Branches Git"
echo "=========================================="

cd ~/projet-devops-git 2>/dev/null || {
    mkdir -p ~/projet-devops-git && cd ~/projet-devops-git
    git init && git config user.name "Leonel PENGOU"
    git config user.email "leonelpengou10@gmail.com"
    echo "# Projet" > README.md
    git add . && git commit -m "feat: initial commit"
}

echo ""
echo ">>> ETAPE 1 : Etat actuel du repo"
git log --oneline --graph --all

# ----- STRATEGIE 1 : Feature Branch -----
echo ""
echo ">>> ETAPE 2 : Feature Branch (strategie standard)"
git checkout -b feature/add-api
cat > api.py << 'EOF'
# API DevOps - Feature Branch
def get_status():
    return {"status": "ok", "version": "1.0"}
EOF
git add api.py
git commit -m "feat: add API status endpoint"
echo "Feature branch creee et committee ✓"

# Fast-forward merge
git checkout main
git merge feature/add-api
echo "Fast-forward merge effectue ✓"
git branch -d feature/add-api

# ----- STRATEGIE 2 : No-ff Merge -----
echo ""
echo ">>> ETAPE 3 : Three-way merge (--no-ff)"
git checkout -b feature/monitoring
cat > monitor.py << 'EOF'
# Monitoring - No-FF Branch
def check_health():
    return {"cpu": "ok", "memory": "ok", "disk": "ok"}
EOF
git add monitor.py
git commit -m "feat: add health monitoring"
git checkout main
git merge --no-ff feature/monitoring -m "merge: feature/monitoring -> main"
git branch -d feature/monitoring
echo "No-ff merge effectue ✓"

# ----- STRATEGIE 3 : Release Branch -----
echo ""
echo ">>> ETAPE 4 : Release Branch"
git checkout -b release/v1.0
cat > CHANGELOG.md << 'EOF'
# CHANGELOG
## v1.0.0
- API status endpoint
- Health monitoring
- Deploiement AWS EC2
EOF
git add CHANGELOG.md
git commit -m "chore: prepare release v1.0.0"
git checkout main
git merge --no-ff release/v1.0 -m "merge: release/v1.0 -> main"
git tag -a v1.0.0 -m "Release stable v1.0.0"
git branch -d release/v1.0
echo "Release v1.0.0 creee et taguee ✓"

# ----- STRATEGIE 4 : Hotfix -----
echo ""
echo ">>> ETAPE 5 : Hotfix Branch"
git checkout -b hotfix/fix-api-bug
sed -i 's/version": "1.0"/version": "1.0.1"/' api.py
git add api.py
git commit -m "fix: correct API version number"
git checkout main
git merge --no-ff hotfix/fix-api-bug -m "merge: hotfix/fix-api-bug -> main"
git branch -d hotfix/fix-api-bug
echo "Hotfix applique ✓"

# ----- CHERRY-PICK -----
echo ""
echo ">>> ETAPE 6 : Cherry-pick demo"
git checkout -b develop
echo "# Dev notes" > dev-notes.md
git add dev-notes.md
git commit -m "docs: add dev notes"
COMMIT_ID=$(git log --oneline | head -1 | awk '{print $1}')
git checkout main
git cherry-pick $COMMIT_ID
echo "Cherry-pick du commit $COMMIT_ID effectue ✓"

# ----- STASH -----
echo ""
echo ">>> ETAPE 7 : Git Stash demo"
echo "# Work in progress" > wip.py
git stash
echo "Stash sauvegarde ✓"
git stash list
git stash pop
rm -f wip.py

# ----- HISTORIQUE FINAL -----
echo ""
echo ">>> ETAPE 8 : Historique final"
git log --oneline --graph --all

echo ""
echo ">>> Tags crees :"
git tag -l

echo ""
echo "=========================================="
echo " JOUR 07 TERMINE !"
echo " Strategies maitrisees :"
echo "   ✅ Feature Branch"
echo "   ✅ Fast-forward merge"
echo "   ✅ Three-way merge (--no-ff)"
echo "   ✅ Release Branch"
echo "   ✅ Hotfix Branch"
echo "   ✅ Cherry-pick"
echo "   ✅ Git Stash"
echo "   ✅ Tags semantiques"
echo "=========================================="
