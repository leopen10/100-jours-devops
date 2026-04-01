# Jour 12 — Projet Pratique avec AWS CodeBuild et GitHub 🚀

> ⏱️ Durée : 42 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif du Projet

Construire un pipeline CI/CD complet :
```
GitHub (code) → AWS CodeBuild (build+test) → S3 (artefact) → CodeDeploy (deploy)
```

---

## ☁️ AWS S3 — Stockage des Artefacts

### Qu'est-ce qu'un bucket S3 ?
**Amazon S3 (Simple Storage Service)** est un service de stockage cloud scalable et sécurisé. Un **bucket S3** est un conteneur d'objets avec un nom unique globalement dans AWS.

### Cas d'usage S3 pour DevOps
```
✅ Stocker les artefacts de build (zip, war, exe)
✅ Héberger un site statique
✅ Source de données CodePipeline
✅ Stockage des logs CodeBuild
✅ Backup et archivage
```

### Créer un bucket S3
```
Console AWS → S3 → Create Bucket
  ├── Bucket name : devops-leonel-artefacts (unique globalement)
  ├── Region : us-east-1
  ├── Block public access : ✅ (par défaut)
  └── Versioning : Activer (recommandé)
```

---

## 🏗️ AWS CodePipeline — Orchestration

```
PIPELINE
  └── STAGE 1 : Source (GitHub/CodeCommit)
       └── ACTION : Détecter les changements
  └── STAGE 2 : Build (CodeBuild)
       └── ACTION : Compiler + Tester
  └── STAGE 3 : Deploy (CodeDeploy/S3)
       └── ACTION : Déployer en production
```

### Termes importants
| Terme | Description |
|-------|-------------|
| **Pipeline** | Workflow complet d'automatisation |
| **Stage** | Étape du pipeline (Source, Build, Deploy) |
| **Action** | Tâche dans un stage |
| **Artifact** | Fichier produit entre les stages (stocké S3) |
| **Source Revision** | Version du code source (commit SHA) |

### Types d'exécutions
```
STOPPED    → Arrêté manuellement
FAILED     → Échec d'une étape
SUPERSEDED → Remplacé par une exécution plus récente
```

---

## 🔄 CI/CD — Continuous Integration vs Delivery vs Deployment

```
Continuous Integration (CI)
  → Intégrer et tester le code automatiquement à chaque push

Continuous Delivery (CD)
  → Prêt à déployer, mais nécessite validation manuelle
  → Évite les déploiements trop fréquents

Continuous Deployment (CD)
  → Déploiement automatique SANS intervention manuelle
  → Chaque commit validé va en production
```

---

## 📋 Projet Pratique — Pipeline Complet

### Structure du projet
```
mon-projet-devops/
├── app.py                 # Flask API
├── requirements.txt       # Dépendances
├── tests/
│   └── test_app.py       # Tests pytest
├── buildspec.yml          # Config CodeBuild
├── appspec.yml            # Config CodeDeploy
└── scripts/
    ├── install.sh         # Installation des dépendances
    ├── start.sh           # Démarrage de l'app
    └── validate.sh        # Validation du service
```

### buildspec.yml pour le projet
```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.11
    commands:
      - pip install -r requirements.txt

  pre_build:
    commands:
      - echo "Debut build $(date)"

  build:
    commands:
      - pytest tests/ -v
      - echo "Tests OK !"

  post_build:
    commands:
      - zip -r artefact.zip app.py requirements.txt appspec.yml scripts/

artifacts:
  files:
    - artefact.zip
  discard-paths: yes
```

### scripts/install.sh
```bash
#!/bin/bash
cd /home/ubuntu/flaskapp
pip install -r requirements.txt
```

### scripts/start.sh
```bash
#!/bin/bash
cd /home/ubuntu/flaskapp
python app.py &
echo "App démarrée !"
```

### scripts/validate.sh
```bash
#!/bin/bash
sleep 3
curl -f http://localhost:5000/health || exit 1
echo "Service validé !"
```

---

## 🔐 Politique S3 pour CodeBuild

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::devops-leonel-artefacts",
        "arn:aws:s3:::devops-leonel-artefacts/*"
      ]
    }
  ]
}
```

---

## ✅ Ce qu'on a déjà pratiqué

```
✅ GitHub connecté à EC2 via SSH
✅ Tests pytest 3/3 PASSED sur Flask API
✅ buildspec.yml créé et validé (Jour 10)
✅ appspec.yml créé (Jour 11)
✅ Site déployé sur EC2 via script deploy.sh (Jour 09)
✅ Pipeline GitHub Actions (ancien Jour 08) → équivalent CodeBuild
```

---

## ➡️ Prochain Jour

[Jour 13 — Déploiement Automatique d'un Site Statique avec CodeBuild et S3](../jour-13-deploiement-statique-codebuild-s3/)
