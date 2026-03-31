# Jour 05 — Introduction au Contrôle de Version (Git) 🔧

> ⏱️ Durée : 22 min | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi le Contrôle de Version ?

Le contrôle de version est **indispensable** en DevOps :
- Suivre l'historique de chaque modification du code
- Collaborer en équipe sans écraser le travail des autres
- Revenir à une version précédente en cas de bug
- Gérer des branches pour les nouvelles fonctionnalités

**Pipeline DevOps :**
```
CODE → SOURCE → BUILD → TEST → DEPLOY
  ↑
  Git (Contrôle de Version)
```

---

## 🛠️ Les Outils de Contrôle de Version

| Outil | Type | Usage |
|-------|------|-------|
| **Git** | Distribué | Le standard mondial |
| **GitHub** | Plateforme Git | Hébergement + collaboration |
| **GitLab** | Plateforme Git | CI/CD intégré |
| **BitBucket** | Plateforme Git | Intégration Atlassian |
| **AWS CodeCommit** | Plateforme Git | Cloud AWS |
| **SVN/CVS** | Centralisé | Ancien (legacy) |

---

## 📚 Concepts Fondamentaux

### Git vs SVN
```
GIT (Distribué) :
  Dev1 ←→ Repo Central ←→ Dev2
  Chaque dev a une copie complète du repo → plus rapide, offline possible

SVN (Centralisé) :
  Dev1 → Serveur Central ← Dev2
  Un seul point de vérité → risque si le serveur tombe
```

### Les Rôles du Contrôle de Version
- **Versioning** — Historique complet de chaque modification
- **Branching** — feature, bug, documentation, refactor
- **Merging** — Fusionner les branches
- **Collaboration** — Travail en équipe simultané
- **CI/CD** — Déclencheur des pipelines automatiques
- **Compliance** — Traçabilité pour les audits

---

## ⌨️ Commandes Git Essentielles

### Initialisation et Configuration
```bash
git init                          # Initialiser un repo local
git config --global user.name "Leonel PENGOU"
git config --global user.email "leonelpengou10@gmail.com"
git config --list                 # Voir la configuration
```

### Cycle de Vie des Fichiers
```bash
git status                        # État des fichiers
git add fichier.txt               # Ajouter un fichier
git add .                         # Ajouter tous les fichiers
git commit -m "message clair"     # Enregistrer les changements
git log                           # Historique des commits
git log --oneline                 # Historique condensé
```

### Branches
```bash
git branch                        # Lister les branches
git branch feature/ma-feature     # Créer une branche
git checkout feature/ma-feature   # Changer de branche
git checkout -b feature/nouvelle  # Créer + basculer
git merge feature/ma-feature      # Fusionner une branche
git branch -d feature/ma-feature  # Supprimer une branche
```

### Comparaison et Annulation
```bash
git diff                          # Différences non stagées
git diff --staged                 # Différences stagées
git diff <id-commit>              # Diff avec un commit
git reset --hard <id-commit>      # Revenir à un commit (danger!)
git revert <id-commit>            # Annuler un commit (sûr)
```

### Connexion avec GitHub
```bash
git remote add origin <url>       # Connecter au repo distant
git push origin main              # Envoyer les commits
git pull origin main              # Récupérer les changements
git clone <url>                   # Cloner un repo
```

---

## 🔄 Workflow Git DevOps

```
1. git clone / git init
2. git checkout -b feature/nouvelle-fonctionnalite
3. # Faire les modifications
4. git add .
5. git commit -m "feat: ajouter nouvelle fonctionnalité"
6. git push origin feature/nouvelle-fonctionnalite
7. # Créer une Pull Request sur GitHub
8. # Code Review par l'équipe
9. git merge → main
10. # CI/CD se déclenche automatiquement
```

---

## 🏋️ Projet Pratique

Voir [`exercices.sh`](./exercices.sh) pour le projet complet :
- Initialiser un repo Git local
- Créer des commits avec un historique propre
- Gérer des branches feature
- Connecter au repo GitHub distant

---

## ➡️ Prochain Jour

[Jour 06 — Git Avancé : Branches, Merge, Rebase](../jour-06-git-avance/)
