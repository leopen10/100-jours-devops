# Jour 06 — Git Avancé : Branches, Merge, Rebase & GitHub 🔀

> ⏱️ Durée : ~45 min | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🌿 1. Stratégie des Branches

### Les types de branches
```
main/master  → Branche principale, toujours stable et en production
feature/xxx  → Nouvelle fonctionnalité
release/vX   → Version prête à livrer aux utilisateurs
fix/xxx      → Correction de bug
hotfix/xxx   → Correction urgente en production
```

### Exemple de workflow (projet Kubernetes)
```
main ─────────────────────────────────────→ release-v1
  │
  ├── feature/add-number ──→ tests ──→ merge dans main
  │
  ├── feature/UI-designer ──→ merge dans main
  │
  └── fix/bug-123 ──────────→ merge dans main
```

---

## ⚡ 2. Commandes Branches Avancées

```bash
# Lister toutes les branches (locales + distantes)
git branch -a

# Créer et basculer
git checkout -b feature/nouvelle
git switch -c feature/nouvelle    # nouvelle syntaxe

# Supprimer une branche
git branch -d feature/ancienne    # si mergée
git branch -D feature/ancienne    # forcer la suppression

# Voir l'historique graphique
git log --oneline --graph --all
```

---

## 🔀 3. Merge vs Rebase

### Merge — Fusionner deux branches
```bash
git checkout main
git merge feature/ma-feature

# Types de merge :
# Fast-forward : pas de commit de merge (historique linéaire)
# 3-way merge  : crée un commit de merge (historique ramifié)
```

```
Avant merge :          Après merge (3-way) :
main: A─B              main: A─B─────M
          \                       \   /
feature:   C─D         feature:   C─D
```

### Rebase — Réécrire l'historique
```bash
git checkout feature/ma-feature
git rebase main

# Résultat : historique linéaire, plus propre
```

```
Avant rebase :         Après rebase :
main: A─B              main: A─B
          \                       \
feature:   C─D         feature:    C'─D'
```

### Quand utiliser lequel ?
| Situation | Recommandation |
|-----------|---------------|
| Branche publique partagée | **Merge** |
| Branche feature locale | **Rebase** |
| Historique propre | **Rebase** |
| Traçabilité complète | **Merge** |

---

## 🍒 4. Cherry-pick — Sélectionner des commits

```bash
# Appliquer un commit spécifique sur la branche courante
git cherry-pick <id-commit>

# Exemple : appliquer le commit b3a85ed sur main
git checkout main
git cherry-pick b3a85ed

# Plusieurs commits
git cherry-pick id1 id2 id3
```

---

## 🔑 5. Connexion SSH avec GitHub

### Générer une clé SSH
```bash
ssh-keygen -t rsa -b 4096 -C "leonelpengou10@gmail.com"
# Appuyer Enter 3 fois (chemin par défaut, pas de passphrase)
```

### Ajouter la clé publique sur GitHub
```bash
cat ~/.ssh/id_rsa.pub
# Copier le contenu → GitHub → Settings → SSH Keys → New SSH Key → Coller
```

### Tester la connexion
```bash
ssh -T git@github.com
# Réponse : "Hi leopen10! You've successfully authenticated"
```

### Utiliser SSH au lieu de HTTPS
```bash
git remote set-url origin git@github.com:leopen10/100-jours-devops.git
git remote -v    # Vérifier
```

---

## 🍴 6. Fork et Clone

### Fork
- Copie un repo d'un autre utilisateur dans ton compte GitHub
- Permet de contribuer sans toucher au repo original
- Workflow : Fork → Clone → Modif → Push → Pull Request

### Clone
```bash
# Cloner un repo (HTTPS)
git clone https://github.com/leopen10/100-jours-devops.git

# Cloner un repo (SSH - recommandé)
git clone git@github.com:leopen10/100-jours-devops.git

# Cloner dans un dossier spécifique
git clone <url> mon-dossier
```

---

## 📤 7. Pull Request (PR)

```
1. Fork le repo original
2. git clone ton fork
3. git checkout -b feature/ma-contribution
4. # Faire les modifications
5. git add . && git commit -m "feat: ma contribution"
6. git push origin feature/ma-contribution
7. Sur GitHub → "Compare & Pull Request"
8. Rédiger la description → "Create Pull Request"
9. Attendre la review → Merge !
```

---

## 🔧 Commandes Récapitulatives

```bash
ssh -T git@github.com              # Tester connexion SSH GitHub
ls -lrta                           # Lister fichiers avec dates
git remote -v                      # Voir les remotes configurés
ssh-keygen -t rsa -b 4096 -C "email"  # Générer clé SSH
git log --oneline                  # Historique condensé
git cherry-pick <id>               # Appliquer un commit
git merge <branche>                # Fusionner
git rebase <branche>               # Rebaser
```

---

## 🏋️ Projet Pratique

Voir [`exercices.sh`](./exercices.sh) — Simulation complète d'un workflow Git professionnel avec branches, merge, rebase et connexion SSH.

---

## ➡️ Prochain Jour

[Jour 07 — Shell Scripting Bash](../jour-07-shell-scripting/)

---

## ✅ Preuve d'exécution sur AWS EC2
```
* ca24ffc (HEAD -> main) chore: add changelog v1.0
| * fec690f (release/v1.0) chore: add changelog v1.0
|/
* b3a85ed (feature/monitoring) feat: add monitoring script
* 85aa692 feat: initial commit - projet devops jour 5

Commits  : 3
Branches : 3 (main, feature/monitoring, release/v1.0)
Clé SSH  : ✅ Générée et ajoutée sur GitHub
```

- **Serveur :** AWS EC2 Ubuntu 24.04 — us-east-1
