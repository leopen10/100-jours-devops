# Jour 07 — Stratégies de Branches Git et Questions d'Entretien 🌿

> ⏱️ Durée : 18 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Maîtriser les stratégies de branches Git utilisées en entreprise et savoir répondre aux questions d'entretien DevOps sur Git.

---

## 🌿 Les Types de Branches

```
main/master   → Code stable, prêt pour la PRODUCTION
develop       → Intégration continue
feature/xyz   → Nouvelle fonctionnalité
release/vX    → Version prête à livrer aux utilisateurs
hotfix/xyz    → Correctif urgent en production
bugfix/xyz    → Correction de bug
```

### Exemple réel
```
main ──────────────────────────────────→ release-v1
  ├── feature/add-number ──→ tests ──→ merge main
  ├── feature/UI-designer ──→ merge main
  └── bugfix/fix-login ────→ merge main
```

---

## 🔀 Les 4 Stratégies de Merge

### 1. Fast-Forward
```bash
git checkout main && git merge feature/ma-feature
# Historique linéaire — pas de commit de merge
```

### 2. Three-Way Merge (--no-ff)
```bash
git merge --no-ff feature/ma-feature -m "merge: feature -> main"
# Crée un commit de merge — historique ramifié
```

### 3. Squash Merge
```bash
git merge --squash feature/ma-feature
git commit -m "feat: add nouvelle fonctionnalite"
# Tous les commits de la feature → 1 seul commit
```

### 4. Rebase
```bash
git checkout feature/ma-feature
git rebase main
# Historique linéaire, réécrit les commits
```

---

## 🍒 Cherry-pick

```bash
git log --oneline           # Trouver l'ID du commit
git cherry-pick <id>        # Appliquer sur la branche courante
git cherry-pick id1 id2 id3 # Plusieurs commits
```

---

## 🔑 Commandes Essentielles

```bash
git branch -a                      # Lister toutes les branches
git checkout -b feature/nouvelle   # Créer et basculer
git branch -d feature/ancienne     # Supprimer (si mergée)
git log --oneline --graph --all    # Voir l'historique graphique
git stash                          # Sauvegarder sans committer
git stash pop                      # Restaurer le stash
git remote -v                      # Voir les remotes
ssh -T git@github.com              # Tester connexion SSH GitHub
```

---

## ❓ Questions d'Entretien DevOps — Git

**Q1 : Merge vs Rebase ?**
Merge crée un commit de fusion et préserve l'historique. Rebase réécrit les commits pour un historique linéaire. Merge pour branches partagées, rebase pour branches locales.

**Q2 : Qu'est-ce que le Git Flow ?**
Stratégie de branches : `main` (prod), `develop` (intégration), `feature/*`, `release/*`, `hotfix/*`.

**Q3 : Qu'est-ce qu'une Pull Request ?**
Demande de fusion de code sur GitHub. Permet la revue de code avant intégration dans main.

**Q4 : Comment résoudre un conflit Git ?**
```bash
git merge feature/xyz     # Déclenche le conflit
# Éditer les fichiers (chercher <<<<<<<)
git add fichier.py
git commit -m "fix: resolve merge conflict"
```

**Q5 : git fetch vs git pull ?**
`git fetch` récupère sans appliquer. `git pull` = `git fetch` + `git merge`.

**Q6 : Qu'est-ce que git cherry-pick ?**
Applique un commit spécifique d'une branche sur une autre sans merger toute la branche.

**Q7 : Qu'est-ce que git stash ?**
Sauvegarde temporaire des modifications non committées. `git stash` → sauvegarder, `git stash pop` → restaurer.

---

## 🏋️ Projet Pratique

Voir [`exercices.sh`](./exercices.sh)

---


## ✅ Preuve d'exécution sur AWS EC2

**Serveur :** Ubuntu 24.04 — AWS EC2 t3.micro — us-east-1  
**Date :** 1 avril 2026
```
* c8ec362 (HEAD -> develop, tag: v1.0.0, main) chore: prepare release v1.0.0
* a45e886 feat: add health monitoring
* 210b026 feat: add API status endpoint
* ca24ffc chore: add changelog v1.0
| * fec690f (release/v1.0) chore: add changelog v1.0
|/
* b3a85ed feat: add monitoring script
* 85aa692 feat: initial commit

Tags : v1.0.0 ✅
```
---

## ➡️ Prochain Jour

[Jour 08 — Fork, Clone, branches, Merge, Rebase et Gestion des Conflits](../jour-08-fork-clone-merge-rebase/)
