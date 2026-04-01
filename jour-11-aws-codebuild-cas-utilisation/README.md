# Jour 11 — Les Cas d'Utilisation d'AWS CodeBuild 🔨

> ⏱️ Durée : 32 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Pipeline AWS DevOps Complet

```
Écrire le code     → Cloud9 / VSCode
Stocker le code    → AWS CodeCommit (git + github)
Build + Test       → AWS CodeBuild
Déployer           → AWS CodeDeploy (automatisé)
Logger + Monitorer → CloudTrail + CloudWatch
Orchestrer         → AWS CodePipeline
```

### Destination du déploiement
```
CodeDeploy → EC2 (serveurs)
           → Lambda (serverless)
           → ECS (containers)
           → EKS (Kubernetes)
```

---

## 🏗️ CodeBuild — Les 5 Cas d'Utilisation Détaillés

### 1️⃣ CI/CD — Intégration et Déploiement Continus
```
Source Code → BUILD → TEST → DEPLOY → MONITORING
    ↓
Fichiers logs générés à chaque étape
```
Chaque push sur GitHub déclenche automatiquement le pipeline.

### 2️⃣ Building et Packaging du Software
```
buildspec.yml → Artefact (S3)
```
Types d'artefacts produits :
- `app code` — code source packagé
- `.exe` — exécutable compilé
- `config file` — fichiers de configuration
- `.zip / .war` — archives déployables

### 3️⃣ Tests Automatisés
| Framework | Langage |
|-----------|---------|
| **JUnit** | Java |
| **NUnit** | .NET |
| **pytest** | Python |
| **Selenium** | Tests CRUD (Create, Retrieve, Update, Delete) |

Résultat : rapport de tests automatique envoyé à S3 ou CloudWatch.

### 4️⃣ Infrastructure as Code (IaC)
```
CodeBuild déclenche :
  ├── aws cloudformation deploy
  ├── terraform apply
  └── ansible-playbook
```
Crée automatiquement VMs, bases de données, réseaux.

### 5️⃣ Build Docker Container
```
Dockerfile → CodeBuild → Image Docker → Amazon ECR → ECS / EKS
```

---

## 🚀 AWS CodeDeploy — Pourquoi l'utiliser ?

### Méthodes de déploiement comparées

| Méthode | Avantages | Inconvénients |
|---------|-----------|---------------|
| **Manuel** | Simple | Lent, source d'erreurs, pas scalable |
| **Scripts** | Automatisé | Complexe à maintenir |
| **CodeDeploy** | Automatisé + scalable + rollback | Apprentissage initial |

### Avantages de CodeDeploy
```
✅ Automatisation complète du déploiement
✅ Déploiement sur plusieurs serveurs (Deployment Group)
✅ Rollback automatique en cas d'échec
✅ Zéro downtime (Blue/Green deployment)
✅ Intégration native AWS (EC2, Lambda, ECS)
✅ Monitoring et logs automatiques
```

---

## 🔐 IAM Policy — Sécurité CodeBuild/CodeDeploy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowFullAccess",
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    },
    {
      "Sid": "DenyIAMModifications",
      "Effect": "Deny",
      "Action": [
        "iam:DeleteUser",
        "iam:DeleteRole",
        "iam:DeletePolicy",
        "iam:DetachRolePolicy",
        "iam:CreatePolicyVersion"
      ],
      "Resource": "*"
    }
  ]
}
```

### Rôles IAM nécessaires pour CodeBuild
```
CodeBuildServiceRole
  ├── AmazonS3FullAccess      (artefacts)
  ├── CloudWatchLogsFullAccess (logs)
  ├── AmazonEC2ContainerRegistryFullAccess (Docker)
  └── SecretsManagerReadWrite  (secrets)
```

---

## 📄 appspec.yml — Fichier de déploiement CodeDeploy

```yaml
version: 0.0
os: linux

files:
  - source: /
    destination: /var/www/html/

hooks:
  BeforeInstall:
    - location: scripts/install_dependencies.sh
      timeout: 300
      runas: root

  AfterInstall:
    - location: scripts/start_server.sh
      timeout: 300
      runas: root

  ApplicationStart:
    - location: scripts/validate_service.sh
      timeout: 300
      runas: root
```

---

## 🏋️ Projet Pratique — buildspec.yml Complet

Voir [`buildspec.yml`](./buildspec.yml) — pipeline CI/CD complet pour notre Flask API.

---

## ✅ Ce qu'on a déjà pratiqué

```
✅ Pipeline CI/CD : Code → Build → Test → Deploy (Jour 09)
✅ Tests automatisés : pytest 3/3 PASSED (Jour 08)
✅ Déploiement EC2 : Site Nginx live http://44.222.105.23 (Jour 03)
✅ Docker : Image buildée et lancée (leopen10/flaskapp-devops:v1)
✅ IAM : Rôles et politiques compris
```

---

## ➡️ Prochain Jour

[Jour 12 — Projet Pratique avec AWS CodeBuild et GitHub](../jour-12-projet-codebuild-github/)
