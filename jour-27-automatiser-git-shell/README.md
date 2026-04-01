# Jour 27 — Automatiser Git avec Shell Scripting et l'API GitHub 🤖

> ⏱️ Durée : 40 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Automatiser les tâches Git répétitives avec des scripts Shell et l'API GitHub.

---

## 1️⃣ Automatiser Git avec Shell

### Script de commit automatique
```bash
#!/bin/bash
# auto_commit.sh - Commit et push automatique
# Auteur : Leonel-Magloire PENGOU MBA

REPO_DIR="/home/ubuntu/100-jours-devops"
MESSAGE="auto: mise a jour automatique $(date '+%Y-%m-%d %H:%M')"

cd $REPO_DIR

# Vérifier s'il y a des changements
if [ -z "$(git status --porcelain)" ]; then
    echo "Aucun changement a committer"
    exit 0
fi

git add .
git commit -m "$MESSAGE"
git push origin main
echo "Commit et push effectues !"
```

### Script de création de branche
```bash
#!/bin/bash
# new_feature.sh - Créer une branche feature

FEATURE=$1
if [ -z "$FEATURE" ]; then
    echo "Usage : ./new_feature.sh nom-feature"
    exit 1
fi

git checkout -b "feature/$FEATURE"
echo "Branche feature/$FEATURE créée !"
```

### Script de synchronisation
```bash
#!/bin/bash
# sync_repos.sh - Synchroniser plusieurs repos

REPOS=(
    "/home/ubuntu/100-jours-devops"
    "/home/ubuntu/django-invoice"
)

for REPO in "${REPOS[@]}"; do
    echo "Syncing $REPO..."
    cd $REPO
    git pull origin main
    echo "✅ $REPO synchronisé"
done
```

---

## 2️⃣ API GitHub avec curl

### Lister les repos
```bash
# Lister ses repos publics
curl -s https://api.github.com/users/leopen10/repos | \
    python3 -c "import sys,json; [print(r['name']) for r in json.load(sys.stdin)]"
```

### Créer un repo
```bash
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d '{"name":"mon-nouveau-repo","private":false,"description":"Créé via API"}'
```

### Créer une issue
```bash
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/leopen10/100-jours-devops/issues \
  -d '{"title":"Bug trouvé","body":"Description du bug","labels":["bug"]}'
```

### Déclencher un workflow GitHub Actions
```bash
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/leopen10/django-invoice/actions/workflows/deploy.yml/dispatches \
  -d '{"ref":"main"}'
```

---

## 3️⃣ Script Complet — Rapport Git

```bash
#!/bin/bash
# git_rapport.sh - Rapport complet des repos GitHub

TOKEN=$GITHUB_TOKEN
USER="leopen10"

echo "=== RAPPORT GITHUB - $(date) ==="
echo ""

# Lister les repos
echo "--- REPOS PUBLICS ---"
curl -s -H "Authorization: token $TOKEN" \
    https://api.github.com/users/$USER/repos | \
    python3 -c "
import sys, json
repos = json.load(sys.stdin)
for r in repos:
    print(f\"{r['name']:30} | Stars: {r['stargazers_count']} | Updated: {r['updated_at'][:10]}\")
"

# Stats du repo principal
echo ""
echo "--- STATS 100-JOURS-DEVOPS ---"
curl -s -H "Authorization: token $TOKEN" \
    https://api.github.com/repos/$USER/100-jours-devops | \
    python3 -c "
import sys, json
r = json.load(sys.stdin)
print(f\"Stars    : {r['stargazers_count']}\")
print(f\"Forks    : {r['forks_count']}\")
print(f\"Issues   : {r['open_issues_count']}\")
print(f\"Updated  : {r['updated_at'][:10]}\")
"

echo "=== FIN DU RAPPORT ==="
```

---

## ✅ Scripts utilisés dans la formation

```bash
✅ deploy.sh          → Déploiement Jour 09
✅ aws_surveillance.sh → Surveillance AWS Jour 26
✅ .github/workflows/ → Pipeline CI/CD Jour 12-13-22
```

---

## ➡️ Prochain Jour

[Jour 28 — Top 15 Services AWS pour DevOps](../jour-28-top-15-services-aws/)
