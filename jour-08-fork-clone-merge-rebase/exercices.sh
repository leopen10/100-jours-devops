#!/bin/bash
# ============================================================
# Jour 08 - Fork, Clone, Merge, Rebase et Gestion des Conflits
# Projet : Workflow complet avec conflits réels
# ============================================================

echo "=========================================="
echo " JOUR 08 - Fork Clone Merge Rebase"
echo "=========================================="

# ----- SETUP -----
cd ~/projet-devops-git 2>/dev/null || {
    mkdir -p ~/projet-devops-git && cd ~/projet-devops-git
    git init && git config user.name "Leonel PENGOU"
    git config user.email "leonelpengou10@gmail.com"
    echo "# Projet DevOps" > README.md
    git add . && git commit -m "feat: initial commit"
}

# Résoudre tout conflit existant
git merge --abort 2>/dev/null || true
git rebase --abort 2>/dev/null || true
git checkout main 2>/dev/null || true

echo ""
echo ">>> ETAPE 1 : Vérification SSH GitHub"
ssh -T git@github.com 2>&1 | grep -E "Hi|successfully|denied" || echo "SSH non configuré"
git remote -v

# ----- MERGE AVEC CONFLIT -----
echo ""
echo ">>> ETAPE 2 : Créer un conflit et le résoudre"

# Branche A modifie config.py
git checkout -b feature/config-A
cat > config.py << 'EOF'
# Configuration - Branche A
DATABASE = "postgresql://localhost:5432/devops_a"
DEBUG = True
VERSION = "1.0.0-A"
EOF
git add config.py
git commit -m "feat: add config from branch A"

# Main modifie aussi config.py
git checkout main
cat > config.py << 'EOF'
# Configuration - Main
DATABASE = "postgresql://localhost:5432/devops_main"
DEBUG = False
VERSION = "1.0.0"
EOF
git add config.py
git commit -m "feat: add config from main"

# Merger → Conflit !
echo "Merge avec conflit intentionnel..."
git merge feature/config-A || true

# Résoudre le conflit automatiquement
cat > config.py << 'EOF'
# Configuration - Resolue (merge feature/config-A + main)
DATABASE = "postgresql://localhost:5432/devops_production"
DEBUG = False
VERSION = "1.0.1"
EOF
git add config.py
git commit -m "fix: resolve merge conflict in config.py"
git branch -d feature/config-A
echo "Conflit résolu ✓"

# ----- REBASE -----
echo ""
echo ">>> ETAPE 3 : Rebase demo"
git checkout -b feature/rebase-demo
echo "# Feature rebased" > feature.py
git add feature.py
git commit -m "feat: feature avant rebase"

# Ajouter un commit sur main pendant ce temps
git checkout main
echo "# Main avance" >> README.md
git add README.md
git commit -m "docs: update README on main"

# Rebaser la feature sur main
git checkout feature/rebase-demo
git rebase main
echo "Rebase effectué ✓"

# Merger dans main
git checkout main
git merge feature/rebase-demo
git branch -d feature/rebase-demo

# ----- CLONE DEMO -----
echo ""
echo ">>> ETAPE 4 : Clone demo (simulé localement)"
cd ~
if [ ! -d ~/clone-demo ]; then
    git clone ~/projet-devops-git ~/clone-demo
    echo "Clone local effectué ✓"
fi
cd ~/clone-demo
git log --oneline | head -5
cd ~/projet-devops-git

# ----- HISTORIQUE FINAL -----
echo ""
echo ">>> ETAPE 5 : Historique final"
git log --oneline --graph --all | head -15

echo ""
echo ">>> Infos du repo"
echo "Commits : $(git log --oneline | wc -l)"
echo "Branches : $(git branch | wc -l)"
echo "Remote : $(git remote -v | head -1)"

echo ""
echo "=========================================="
echo " JOUR 08 TERMINE !"
echo " Concepts maitrises :"
echo "   ✅ Fork et Clone"
echo "   ✅ Merge (fast-forward + 3-way)"
echo "   ✅ Conflit créé et résolu"
echo "   ✅ Rebase sur main"
echo "   ✅ git remote SSH"
echo "   ✅ Historique graphique"
echo "=========================================="
