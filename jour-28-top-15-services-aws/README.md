# Jour 28 — Top 15 Services AWS Essentiels pour les Ingénieurs DevOps ☁️

> ⏱️ Durée : 20 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi ces 15 services ?

AWS propose **200+ services** mais un ingénieur DevOps doit maîtriser ces 15 services clés pour automatiser et optimiser son infrastructure.

---

## 1️⃣ Compute & Sécurité

### ✅ EC2 — Elastic Compute Cloud
```
Rôle    : Machines virtuelles (serveurs cloud)
Usage   : Héberger des applications, serveurs web, APIs
On fait : Instance t3.micro Ubuntu 24.04 → http://44.222.105.23
```

### ✅ VPC — Virtual Private Cloud
```
Rôle    : Réseau privé isolé dans AWS
Usage   : Security Groups, Inbound/Outbound Rules
On fait : SG ouvert port 22 (SSH), 80 (HTTP), 8000 (Dev)
```

### ✅ IAM — Identity and Access Management
```
Rôle    : Gestion des identités et permissions
Usage   : Users, Roles, Policies, MFA
On fait : devops-leonel (AdministratorAccess)
          EC2InstanceProfileCodeDeploy
          CodeDeployServiceRole
```

### ✅ EBS — Elastic Block Store
```
Rôle    : Stockage persistant attaché à EC2
Usage   : Disque dur virtuel de l'instance EC2
On fait : 8 GB sur notre instance (Usage: 48.2%)
```

### ✅ AWS KMS — Key Management Service
```
Rôle    : Gestion des clés de chiffrement
Usage   : Chiffrer S3, EBS, Secrets Manager
```

---

## 2️⃣ Stockage & Logs

### ✅ S3 — Simple Storage Service
```
Rôle    : Stockage d'objets haute disponibilité
Usage   : Artefacts CI/CD, site statique, backups, logs
On fait : devops-artefacts-leonel-2026
          → Site statique déployé automatiquement
          → Artefacts des pipelines Jour 12-13
```

### ✅ CloudWatch
```
Rôle    : Monitoring, métriques et alertes
Usage   : CPU, RAM, logs applicatifs, alarmes
On fait : Monitoring pipeline GitHub Actions
          Logs Gunicorn et Nginx
```

### ✅ CloudTrail
```
Rôle    : Audit et traçabilité de toutes les actions AWS
Usage   : Sécurité, conformité, forensics
On fait : Toutes les actions IAM et EC2 tracées
```

---

## 3️⃣ CI/CD & Déploiement

### ✅ CodeBuild
```
Rôle    : Service de build managé
Usage   : Compiler, tester, packager le code
On fait : Équivalent via GitHub Actions (Jour 12)
          → Build Flask + pytest → 20s
```

### ✅ CodeDeploy
```
Rôle    : Déploiement automatisé sur EC2/Lambda/ECS
Usage   : Blue/Green, Rolling, Canary deployments
On fait : Agent installé sur EC2 (v1.8.1-26)
          Rôles IAM créés (Jour 19)
```

### ✅ CodePipeline
```
Rôle    : Orchestration du pipeline CI/CD complet
Usage   : Source → Build → Test → Deploy
On fait : Équivalent via GitHub Actions (Jour 22)
          → Deploy Django EC2 → 23s
```

---

## 4️⃣ Containers & Serverless

### ✅ ECR — Elastic Container Registry
```
Rôle    : Registry Docker privé AWS
Usage   : Stocker et gérer les images Docker
On fait : leopen10/flaskapp-devops:v1 sur Docker Hub
```

### ✅ ECS — Elastic Container Service
```
Rôle    : Orchestration de containers Docker managée
Usage   : Déployer des containers en production
Prochain: Formation Docker (Jour 29+)
```

### ✅ Lambda
```
Rôle    : Exécution de code serverless (sans serveur)
Usage   : Functions event-driven, automatisation
Avantage: Facturation à l'exécution (pas de serveur permanent)
```

### ✅ Route 53
```
Rôle    : Service DNS managé AWS
Usage   : Gérer les noms de domaine, routing
Exemple : leonel.com → 44.222.105.23
```

---

## 📊 Tableau Récapitulatif

| Service | Catégorie | Notre Usage | Statut |
|---------|-----------|-------------|--------|
| EC2 | Compute | Instance t3.micro Ubuntu | ✅ En prod |
| VPC | Réseau | Security Groups configurés | ✅ |
| IAM | Sécurité | devops-leonel + Rôles | ✅ |
| EBS | Stockage | 8GB sur EC2 | ✅ |
| KMS | Sécurité | Chiffrement secrets | 📚 |
| S3 | Stockage | Site statique + artefacts | ✅ En prod |
| CloudWatch | Monitoring | Logs Nginx + Gunicorn | ✅ |
| CloudTrail | Audit | Toutes les actions tracées | ✅ |
| CodeBuild | CI/CD | GitHub Actions (équivalent) | ✅ |
| CodeDeploy | Deploy | Agent installé sur EC2 | ✅ |
| CodePipeline | CI/CD | GitHub Actions (équivalent) | ✅ |
| ECR | Containers | Docker Hub (équivalent) | ✅ |
| ECS | Containers | À venir (formation Docker) | 📚 |
| Lambda | Serverless | À venir | 📚 |
| Route 53 | DNS | leonel.com bucket S3 | ✅ |

---

## 🎯 Services maîtrisés vs restants

```
✅ Maîtrisés (11/15) :
   EC2, VPC, IAM, EBS, S3, CloudWatch, CloudTrail,
   CodeBuild, CodeDeploy, CodePipeline, ECR

📚 À approfondir (4/15) :
   KMS, ECS, Lambda, Route 53
```

---

## ➡️ Prochain Jour

[Jour 29 — Ansible : Automatisation et Gestion de Configuration](../jour-29-ansible/)
