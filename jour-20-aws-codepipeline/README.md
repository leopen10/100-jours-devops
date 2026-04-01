# Jour 20 — AWS CodePipeline : Introduction et Concepts de Base 🔄

> ⏱️ Durée : 22 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Qu'est-ce qu'AWS CodePipeline ?

AWS CodePipeline est le **chef d'orchestre** du pipeline DevOps AWS. Il automatise et coordinate toutes les étapes du cycle de développement.

```
GitHub/CodeCommit (Source)
         ↓
   CodeBuild (Build + Test)
         ↓
   CodeDeploy (Deploy)
         ↓
   Monitoring (CloudWatch)

Tout ça orchestré automatiquement par CodePipeline !
```

---

## 🔄 CI/CD — Les 3 Concepts

### Intégration Continue (CI)
```
Développeur push du code
         ↓
Tests automatiques lancés
         ↓
Code fusionné si tests OK
         ↓
Feedback immédiat en cas d'erreur
```

### Livraison Continue (CD - Delivery)
```
Code testé → Prêt pour la production
         ↓
Déploiement en préproduction automatique
         ↓
Validation manuelle requise avant prod
```

### Déploiement Continu (CD - Deployment)
```
Code testé → Déployé en production
         ↓
SANS intervention manuelle
         ↓
Utilisé par Netflix, Amazon, Google
```

---

## 🏗️ Architecture CodePipeline

### Composants
```
PIPELINE
  ├── STAGE 1 : Source
  │     └── Action : GitHub webhook → déclenche le pipeline
  │
  ├── STAGE 2 : Build
  │     └── Action : CodeBuild → compile + teste
  │
  ├── STAGE 3 : Test (optionnel)
  │     └── Action : Tests d'intégration
  │
  ├── STAGE 4 : Deploy Staging
  │     └── Action : CodeDeploy → environnement de test
  │
  └── STAGE 5 : Deploy Production
        └── Action : CodeDeploy → production
              (avec approbation manuelle optionnelle)
```

### Termes Clés
| Terme | Description |
|-------|-------------|
| **Pipeline** | Workflow complet d'automatisation |
| **Stage** | Étape du pipeline (Source, Build, Deploy) |
| **Action** | Tâche dans un stage |
| **Artifact** | Fichier transmis entre les stages (S3) |
| **Transition** | Lien entre deux stages |
| **Execution** | Une instance du pipeline qui tourne |

---

## ⚡ Types d'Exécutions

```
STARTED    → Pipeline déclenché
IN_PROGRESS → En cours d'exécution
SUCCEEDED  → Toutes les étapes OK ✅
FAILED     → Une étape a échoué ❌
STOPPED    → Arrêté manuellement
SUPERSEDED → Remplacé par une nouvelle exécution
```

---

## 🔌 Intégrations CodePipeline

### Sources supportées
```
✅ GitHub / GitHub Enterprise
✅ AWS CodeCommit
✅ Amazon S3
✅ Bitbucket
✅ GitLab
```

### Actions Build
```
✅ AWS CodeBuild
✅ Jenkins
✅ CloudBees
```

### Actions Deploy
```
✅ AWS CodeDeploy (EC2, Lambda, ECS)
✅ Amazon S3
✅ AWS Elastic Beanstalk
✅ Amazon ECS
✅ AWS CloudFormation
```

---

## 💰 Tarification

```
1 pipeline actif/mois : GRATUIT (Free Tier)
Pipeline supplémentaire : $1/mois

Action V1 : $0.002 par exécution
Action V2 : basé sur les minutes d'exécution
```

---

## ✅ Notre Équivalent — GitHub Actions

Notre pipeline (Jours 12-13) fait exactement la même chose :

```
GitHub Push (Source)
      ↓
GitHub Actions (Build + Test + Deploy)
      ├── Jour 12 : build → pytest → package → artefact ✅
      └── Jour 13 : checkout → aws credentials → s3 deploy ✅

Durées :
  Jour 12 : 20 secondes ✅
  Jour 13 : 14 secondes ✅
```

---

## 🔄 Créer un Pipeline CodePipeline

```
Console AWS → CodePipeline → Pipelines → Créer un pipeline

ÉTAPE 1 - Configuration :
  ├── Nom : devops-leonel-pipeline
  ├── Rôle de service : Nouveau rôle (auto)
  └── Bucket artefacts : devops-artefacts-leonel-2026

ÉTAPE 2 - Source :
  ├── Fournisseur : GitHub (Version 2)
  ├── Connexion : Autoriser GitHub
  ├── Repository : leopen10/100-jours-devops
  └── Branch : main

ÉTAPE 3 - Build :
  ├── Fournisseur : AWS CodeBuild
  └── Projet : devops-leonel-build

ÉTAPE 4 - Deploy :
  ├── Fournisseur : AWS CodeDeploy
  ├── Application : devops-leonel-app
  └── Deployment Group : production
```

---

## ➡️ Prochain Jour

[Jour 21 — Bonnes Pratiques Sécurité et Monitoring avec CodePipeline](../jour-21-codepipeline-securite/)
