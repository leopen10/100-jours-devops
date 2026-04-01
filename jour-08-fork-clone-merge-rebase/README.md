# Jour 08 — Fork, Clone, branches, Merge, Rebase et Gestion des Conflits 🔀

> ⏱️ Durée : 1h17 | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🍴 1. Fork vs Clone

### Fork
Copier un repo d'un autre utilisateur dans **ton propre compte GitHub**.
```
donaldte/Formation-Devops  →  leopen10/Formation-Devops (fork)
```
Permet de contribuer sans toucher au repo original.

### Clone
Copier un repo GitHub **en local** sur ta machine.
```bash
# SSH (recommandé)
git clone git@github.com:leopen10/100-jours-devops.git

# HTTPS
git clone https://github.com/leopen10/100-jours-devops.git
```

### Workflow Fork + Clone + PR
```
1. Fork sur GitHub
2. git clone git@github.com:TON-USERNAME/repo-forke.git
3. git checkout -b feature/ma-contribution
4. # Modifications
5. git add . && git commit -m "feat: contribution"
6. git push origin feature/ma-contribution
7. Pull Request sur GitHub → Review → Merge
```

---

## 🔀 2. Merge

```bash
git checkout main
git merge feature/ma-feature              # Fast-forward
git merge --no-ff feature/ma-feature      # Crée commit de merge
```

```
Fast-forward :  A─B─C─D─E  (linéaire)
3-way merge :   A─B─C───M  (commit de merge M)
                    \D─E/
```

---

## 🔄 3. Rebase

```bash
git checkout feature/ma-feature
git rebase main                    # Rebaser sur main

# Rebase interactif
git rebase -i HEAD~3
# pick   → garder
# squash → fusionner avec précédent
# drop   → supprimer
```

| | Merge | Rebase |
|--|-------|--------|
| Historique | Ramifié | Linéaire |
| Usage | Branches partagées | Branches locales |

---

## ⚔️ 4. Gestion des Conflits

```bash
git merge feature/xyz
# CONFLICT (content): Merge conflict in fichier.py
```

### Anatomie d'un conflit
```
<<<<<<< HEAD
code de ta branche
=======
code de la branche mergée
>>>>>>> feature/xyz
```

### Résolution
```bash
# 1. Éditer le fichier et supprimer les marqueurs
vim fichier.py

# 2. Ajouter le fichier résolu
git add fichier.py

# 3. Finaliser
git commit -m "fix: resolve merge conflict"

# Annuler si nécessaire
git merge --abort
git rebase --abort
```

---

## 🔑 5. Commandes Essentielles

```bash
ssh -T git@github.com                          # Tester SSH GitHub
ssh-keygen -t rsa -b 4096 -C "email"          # Générer clé SSH
ls -lrta ~/.ssh/                               # Lister clés SSH
git remote -v                                  # Voir les remotes
git remote set-url origin git@github.com:...  # Changer remote en SSH
git clone git@github.com:user/repo.git        # Cloner via SSH
git merge branch_name                          # Merger
git rebase branch_name                         # Rebaser
git cherry-pick <id>                           # Cherry-pick
git log --oneline --graph --all               # Historique graphique
git merge --abort                              # Annuler merge
```

---

## ✅ Preuve d'exécution sur AWS EC2
**Date :** 1 avril 2026 | **Serveur :** Ubuntu 24.04 — us-east-1
```
✅ SSH GitHub  : Hi leopen10! You've successfully authenticated
✅ Remote SSH  : git@github.com:leopen10/100-jours-devops.git
✅ Conflit résolu : CHANGELOG.md
✅ Rebase effectué sur main
✅ Clone local simulé
✅ Historique propre : 7 commits, 1 branche, tag v1.0.0
```
**Date :** 1 avril 2026 | **Serveur :** Ubuntu 24.04 — us-east-1

