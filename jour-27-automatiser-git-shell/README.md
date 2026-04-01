# Jour 27 - Automatiser Git avec Shell Scripting et API GitHub

> Date : 1 avril 2026 | Statut : Completed avec preuve

## Objectif
Automatiser les interactions GitHub via Shell Scripting et API GitHub REST.

## Script : github_manager.sh

### Commandes disponibles
```bash
./github_manager.sh repos                              # Lister ses repos
./github_manager.sh branches 100-jours-devops         # Lister les branches
./github_manager.sh issues django-invoice              # Lister les issues
./github_manager.sh issue 100-jours-devops "Titre" "Body"  # Creer une issue
```

## Preuve execution
```
=== MES REPOS GITHUB ===
100-jours-devops   | 2026-04-01 | Stars: 0
django-invoice     | 2026-04-01 | Stars: 0
leopen10           | 2026-03-31 | Stars: 0

=== BRANCHES DE 100-jours-devops ===
main

=== CREATION ISSUE : Jour 27 - Test API GitHub ===
Issue #1 creee : https://github.com/leopen10/100-jours-devops/issues/1
```

## Prochaine etape
Jour 28 - Top 15 Services AWS pour DevOps
