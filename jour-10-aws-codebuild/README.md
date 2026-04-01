# Jour 10 — Introduction Complète à AWS CodeBuild 🏗️

> ⏱️ Durée : 20 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Qu'est-ce qu'AWS CodeBuild ?

AWS CodeBuild est un service **CI/CD entièrement managé** qui compile le code source, exécute les tests et produit des artefacts prêts à déployer.

```
Code Source → CodeBuild → Artefact (S3) → CodeDeploy → Production
```

### Pipeline AWS complet
```
Cloud9/VSCode
    ↓
AWS CodeCommit (git + github)
    ↓
AWS CodeBuild (build + test) → Artefact S3
    ↓
AWS CodeDeploy → EC2 / ECS / Lambda / EKS
    ↓
AWS CodePipeline (orchestration)
    ↓
Monitoring (CloudWatch)
```

---

## ⚙️ Le Processus de Build

Un langage de haut niveau (Python, Java...) est transformé en code exécutable en 4 étapes :

```
1. Compilation  → bytecode
2. Linking      → dépendances et bibliothèques
3. Optimisation → performance
4. Packaging    → artefact final (zip, war, exe...)
```

---

## 🎯 Les 5 Cas d'Utilisation d'AWS CodeBuild

### 1. CI/CD
```
Source Code → BUILD → TEST → DEPLOY → MONITORING
```
Chaque push déclenche automatiquement le pipeline.

### 2. Building et Packaging du Software
```
Code source → buildspec.yml → Artefact (S3)
              (config, exe, zip, war...)
```

### 3. Tests Automatisés
- **JUnit** pour Java
- **NUnit** pour .NET
- **pytest** pour Python
- **Selenium** pour les tests CRUD (Create, Retrieve, Update, Delete)
- Rapport de tests généré automatiquement

### 4. Infrastructure as Code (IaC)
```
VM (manuellement ou automatiquement)
Base de données
Outils : AWS CloudFormation, Terraform
```

### 5. Build Docker Container
```
Dockerfile → CodeBuild → Image Docker → ECR (registry) → ECS/EKS
```

---

## 📄 Le fichier buildspec.yml — Cœur de CodeBuild

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
      - echo "Début du build - $(date)"
      - python --version

  build:
    commands:
      - echo "Compilation et tests..."
      - pytest tests/ --verbose
      - echo "Build terminé"

  post_build:
    commands:
      - echo "Packaging de l'artefact..."
      - zip -r artefact.zip . -x "*.pyc" -x "__pycache__/*"

artifacts:
  files:
    - artefact.zip
  discard-paths: yes
```

### Structure du buildspec.yml
| Phase | Description |
|-------|-------------|
| `install` | Installer les dépendances |
| `pre_build` | Préparation avant le build |
| `build` | Compilation et tests |
| `post_build` | Packaging, notifications |
| `artifacts` | Fichiers à envoyer dans S3 |

---

## 🏆 Avantages d'AWS CodeBuild

| # | Avantage | Description |
|---|----------|-------------|
| 1 | **Fully Managed** | Pas de serveur à gérer |
| 2 | **Intégration AWS** | S3, ECR, CodePipeline, CloudWatch |
| 3 | **Flexibilité** | Python, Java, Node, Docker... |
| 4 | **Sécurité** | IAM (RBAC), chiffrement, VPC, Security Groups |
| 5 | **Cost Effective** | Serverless — pay as you go |

---

## 🔄 Alternatives à CodeBuild

| Outil | Type |
|-------|------|
| **Jenkins** | Self-hosted, très populaire |
| **GitHub Actions** | Intégré à GitHub |
| **GitLab CI** | Intégré à GitLab |
| **CircleCI** | Cloud CI/CD |
| **AWS CodeBuild** | AWS natif |

---

## 🚀 Projet Pratique — buildspec.yml pour notre Flask App

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.11
    commands:
      - pip install flask pytest

  pre_build:
    commands:
      - echo "Test de l'environnement"
      - python --version
      - pip --version

  build:
    commands:
      - echo "Lancement des tests Flask..."
      - pytest test_app.py -v
      - echo "Tests OK !"

  post_build:
    commands:
      - echo "Création de l'artefact..."
      - zip -r flaskapp.zip app.py test_app.py requirements.txt

artifacts:
  files:
    - flaskapp.zip
```

---

## ✅ Preuve d'exécution

Le buildspec.yml a été créé et validé localement sur notre EC2. Les tests pytest tournent déjà en CI sur notre repo GitHub.

```
✅ Pipeline CI/CD compris : Source → Build → Test → Deploy → Monitor
✅ buildspec.yml maîtrisé : install, pre_build, build, post_build, artifacts
✅ Tests automatisés : pytest 3/3 PASSED sur notre Flask API
✅ Artefact S3 : concept compris et appliqué
```

---

## ➡️ Prochain Jour

[Jour 11 — Les Cas d'Utilisation d'AWS CodeBuild](../jour-11-aws-codebuild-cas-utilisation/)
