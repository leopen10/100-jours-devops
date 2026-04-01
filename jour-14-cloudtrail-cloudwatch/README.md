# Jour 14 — Introduction à AWS CloudTrail et CloudWatch (Partie 1) 📊

> ⏱️ Durée : 20 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Monitoring et Logging — Pourquoi c'est crucial ?

En DevOps, surveiller ton infrastructure c'est **savoir ce qui se passe, quand, et par qui** :

```
Création de services → Read, Update, Create, Delete
         ↓
   Qui a fait quoi ?  → CloudTrail (Audit)
   Comment ça se porte ? → CloudWatch (Monitoring)
```

---

## 🕵️ AWS CloudTrail — L'Audit

### Principe : QUI, QUOI, QUAND
CloudTrail enregistre **tous les appels API** sur ton compte AWS.

```
Utilisateur/Service
      ↓
   Action AWS (create EC2, delete S3, push CodeBuild...)
      ↓
   CloudTrail l'enregistre → Log Event
      ↓
   Stocké 90 jours (gratuit) → ou TRAIL → S3 Bucket (illimité)
      ↓
   Alerte → CloudWatch
      ↓
   Analyse → Amazon Athena
```

### Ce que CloudTrail capture
```
✅ Connexions à la console AWS (qui s'est connecté, quand)
✅ Appels API (qui a créé/supprimé/modifié une ressource)
✅ Actions IAM (changements de permissions)
✅ Modifications S3 (qui a uploadé/supprimé un fichier)
✅ Démarrages/arrêts EC2
✅ Modifications CodeBuild/CodeDeploy
```

### Configuration CloudTrail
```
Console AWS → CloudTrail → Create Trail
  ├── Trail name : devops-leonel-trail
  ├── Storage : S3 bucket (devops-artefacts-leonel-2026)
  ├── Log file validation : ✅ Activer
  ├── CloudWatch Logs : ✅ Activer
  └── Management events : ✅ Read + Write
```

---

## 📊 AWS CloudWatch — Le Monitoring

### Rôle
CloudWatch surveille les **métriques** de tous tes services AWS en temps réel.

```
EC2 / CodeBuild / Lambda / S3...
         ↓
    Métriques collectées
         ↓
    CloudWatch Dashboard
         ↓
    Alarme si seuil dépassé → SNS → Email/SMS
```

### Métriques CodeBuild
```
BUILD_DURATION      → Durée du build
BUILD_STATUS        → Failed / Success / In Progress
PHASE_DURATION      → Durée de chaque phase
QUEUED_DURATION     → Temps d'attente en file
DOWNLOAD_SOURCE     → Durée téléchargement du code
```

### Métriques Ressources (CPU, RAM)
```
CPUUTILIZED          → CPU utilisé
CPUUTILIZEDPERCENT   → % CPU
MEMORYUTILIZED       → RAM utilisée
MEMORYUTILIZEDPERCENT → % RAM
STORAGEREADBYTES     → Lecture disque (S3, EBS)
STORAGEWRITEBYTES    → Écriture disque
```

### Créer une Alarme CloudWatch
```
CloudWatch → Alarms → Create Alarm
  ├── Metric : EC2 → CPUUtilization
  ├── Threshold : > 80%
  ├── Period : 5 minutes
  ├── Action : SNS → Email notification
  └── Alarm name : cpu-high-alert
```

---

## 🔗 CloudTrail + CloudWatch — Intégration

```
CloudTrail (Logs API)
      ↓
CloudWatch Logs (Analyse en temps réel)
      ↓
CloudWatch Metrics Filter (Détecter patterns)
      ↓
CloudWatch Alarm (Seuil dépassé)
      ↓
SNS (Notification Email/SMS)
      ↓
Lambda (Action automatique)
```

---

## 🏗️ Monitoring dans CodeBuild

```
AWS Console → CodeBuild → Projets
  ├── Nom du projet
  ├── Statut du build
  └── Détails du build

Métriques disponibles :
  ├── Build Duration
  ├── Build StartTime
  ├── Build Status (Failed/Success/In Progress)
  ├── Environment Usage
  ├── Phase Duration
  └── Phase Status
```

---

## ✅ Preuve — Monitoring de notre pipeline

Notre pipeline GitHub Actions (équivalent CodeBuild) a les mêmes métriques :

```
Jour 12 Pipeline :
  ├── Build Duration   : 20 secondes ✅
  ├── Build Status     : Success ✅
  ├── Phases           : checkout → install → build → package → upload

Jour 13 Pipeline :
  ├── Build Duration   : 14 secondes ✅
  ├── Build Status     : Success ✅
  ├── Phases           : checkout → verify → aws-credentials → s3-deploy
  └── Artefact déployé : s3://devops-artefacts-leonel-2026/site/index.html
```

---

## ➡️ Prochain Jour

[Jour 15 — Logging et Monitoring avec AWS (Partie 2)](../jour-15-logging-monitoring-aws/)
