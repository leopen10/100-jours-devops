#!/bin/bash
# ============================================================
# Jour 06 - Git Avancé : Branches, Merge, Rebase, SSH
# Projet : Workflow Git professionnel complet
# ============================================================

echo "=========================================="
echo " JOUR 06 - Git Avance : Workflow Pro"
echo "=========================================="

# Utiliser le repo du jour 5
cd ~/projet-devops-git 2>/dev/null || {
    mkdir -p ~/projet-devops-git && cd ~/projet-devops-git
    git init
    git config user.name "Leonel PENGOU"
    git config user.email "leonelpengou10@gmail.com"
    echo "# Projet DevOps" > README.md
    git add . && git commit -m "feat: initial commit"
}

echo ""
echo ">>> ETAPE 1 : Voir l'etat actuel"
git log --oneline --graph --all
echo ""

# ----- BRANCHE FEATURE -----
echo ">>> ETAPE 2 : Creer une branche feature"
git checkout -b feature/add-monitoring
echo "Sur branche feature/add-monitoring ✓"

# Ajouter du code
cat > check-services.sh << 'EOF'
#!/bin/bash
# Verifier l'etat des services DevOps
SERVICES=("nginx" "docker" "ssh")
echo "=== Status des Services ==="
for s in "${SERVICES[@]}"; do
    systemctl is-active --quiet $s 2>/dev/null \
        && echo "✅ $s: actif" \
        || echo "❌ $s: inactif"
done
EOF
chmod +x check-services.sh
git add check-services.sh
git commit -m "feat: add service checker script"

# Deuxieme commit sur la feature
cat >> check-services.sh << 'EOF'

# Verifier la memoire
echo ""
echo "=== Memoire ==="
free -h
EOF
git add check-services.sh
git commit -m "feat: add memory check to service checker"
echo "2 commits sur feature ✓"

# ----- BRANCHE RELEASE -----
echo ""
echo ">>> ETAPE 3 : Creer une branche release"
git checkout main
git checkout -b release/v1.0
echo "# Projet DevOps v1.0" > CHANGELOG.md
echo "## v1.0.0 - $(date +%Y-%m-%d)" >> CHANGELOG.md
echo "- Deploiement Nginx sur AWS EC2" >> CHANGELOG.md
echo "- Script de monitoring" >> CHANGELOG.md
git add CHANGELOG.md
git commit -m "chore: add changelog for v1.0"
echo "Branche release/v1.0 creee ✓"

# ----- MERGE -----
echo ""
echo ">>> ETAPE 4 : Merger feature dans main"
git checkout main
git merge feature/add-monitoring --no-ff -m "merge: feature/add-monitoring -> main"
echo "Merge feature -> main ✓"

# ----- CHERRY-PICK -----
echo ""
echo ">>> ETAPE 5 : Cherry-pick depuis release"
RELEASE_COMMIT=$(git log release/v1.0 --oneline | head -1 | awk '{print $1}')
git cherry-pick $RELEASE_COMMIT
echo "Cherry-pick du commit $RELEASE_COMMIT ✓"

# ----- REBASE -----
echo ""
echo ">>> ETAPE 6 : Rebase demo"
git checkout -b feature/rebase-demo
echo "print('Rebase demo')" > rebase-test.py
git add rebase-test.py
git commit -m "feat: rebase demo file"

# Rebaser sur main
git rebase main
echo "Rebase effectue ✓"
git checkout main
git merge feature/rebase-demo
echo "Merge apres rebase ✓"

# ----- SSH SETUP -----
echo ""
echo ">>> ETAPE 7 : Configuration SSH GitHub"
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "leonelpengou10@gmail.com" -f ~/.ssh/id_rsa -N ""
    echo "Cle SSH generee ✓"
    echo ""
    echo "Copie cette cle publique sur GitHub (Settings → SSH Keys) :"
    echo "----------------------------------------"
    cat ~/.ssh/id_rsa.pub
    echo "----------------------------------------"
else
    echo "Cle SSH existante ✓"
    cat ~/.ssh/id_rsa.pub
fi

# ----- HISTORIQUE FINAL -----
echo ""
echo ">>> ETAPE 8 : Historique final du projet"
git log --oneline --graph --all

echo ""
echo ">>> ETAPE 9 : Verifier les remotes"
git remote -v || echo "Pas de remote configure (normal pour repo local)"

echo ""
echo "=========================================="
echo " JOUR 06 TERMINE !"
echo " Commits : $(git log --oneline | wc -l)"
echo " Branches : $(git branch | wc -l)"
echo " Concepts maîtrises :"
echo "   ✅ Branches (feature, release)"
echo "   ✅ Merge (fast-forward + 3-way)"
echo "   ✅ Cherry-pick"
echo "   ✅ Rebase"
echo "   ✅ Cle SSH GitHub"
echo "=========================================="
