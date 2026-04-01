# Jour 21 — Bonnes Pratiques Sécurité et Monitoring avec AWS CodePipeline 🔒

> ⏱️ Durée : 13 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🔒 1. Sécuriser AWS CodePipeline

### Principe du Moindre Privilège
```
❌ Mauvais : AdministratorAccess sur tout
✅ Bon     : Permissions minimales nécessaires

Exemple policy CodePipeline :
  - codepipeline:StartPipelineExecution
  - codepipeline:GetPipeline
  - s3:GetObject (bucket artefacts uniquement)
  - codebuild:StartBuild
  - codedeploy:CreateDeployment
```

### Authentification Multi-Facteur (MFA)
```
Console AWS → IAM → Utilisateurs → devops-leonel
→ Informations d'identification de sécurité
→ Attribuer un périphérique MFA
→ Application d'authentification (Google Authenticator)
```

### AWS Security Services
| Service | Rôle |
|---------|------|
| **AWS WAF** | Protection contre attaques web (XSS, SQL injection) |
| **AWS Shield** | Protection contre attaques DDoS |
| **AWS GuardDuty** | Détection des menaces en temps réel avec ML |
| **AWS KMS** | Gestion des clés de chiffrement |
| **SSL/TLS** | Chiffrement des communications |

### Chiffrement des Données
```
Artefacts S3 → Chiffrement SSE-S3 ou SSE-KMS
Variables d'environnement → AWS Secrets Manager
Connexions → HTTPS/TLS uniquement
Clés AWS → Rotation tous les 90 jours
```

---

## 📊 2. Monitoring avec AWS

### CloudTrail — Audit
```
Qui a déclenché le pipeline ?
Qui a modifié la configuration ?
Qui a supprimé un déploiement ?
→ Toutes les actions tracées dans CloudTrail
```

### CloudWatch — Surveillance
```
Métriques CodePipeline :
  ├── PipelineExecutionAttempt → Nombre d'exécutions
  ├── PipelineExecutionSuccess → Exécutions réussies
  ├── PipelineExecutionFailed  → Exécutions échouées
  └── ActionExecutionTime      → Durée des actions
```

### Alarmes CloudWatch pour CodePipeline
```
CloudWatch → Alarms → Create Alarm
  ├── Metric : PipelineExecutionFailed
  ├── Threshold : >= 1 (moindre échec = alerte)
  ├── Period : 5 minutes
  └── Action : SNS → leonelpengou10@gmail.com
```

### Amazon SNS — Notifications
```
CodePipeline → Settings → Notifications
  ├── Pipeline started → Email
  ├── Pipeline succeeded → Email
  ├── Pipeline failed → Email + SMS
  └── Approval needed → Email
```

---

## 🛡️ 3. Bonnes Pratiques Complètes

### Sécurité
```
✅ MFA activé sur tous les comptes IAM
✅ Permissions minimales (least privilege)
✅ Secrets dans AWS Secrets Manager (jamais en clair)
✅ Chiffrement des artefacts S3 (KMS)
✅ Rotation des clés d'accès tous les 90 jours
✅ GuardDuty activé pour la détection des menaces
✅ CloudTrail activé dans toutes les régions
✅ Audit régulier des permissions IAM
```

### Pipeline
```
✅ Tests obligatoires avant le déploiement
✅ Approbation manuelle avant la production
✅ Rollback automatique en cas d'échec
✅ Notifications d'échec immédiates
✅ Environnements séparés : dev → staging → prod
✅ Tags sur toutes les ressources
```

### Code
```
✅ Scan de sécurité des dépendances (pip-audit)
✅ Analyse statique du code (SonarQube, Bandit)
✅ Tests unitaires + tests d'intégration
✅ Review de code obligatoire (Pull Request)
✅ Secrets jamais dans le code (GitHub Secrets)
```

---

## 🔐 Exemple — Policy IAM Sécurisée pour CodePipeline

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codepipeline:StartPipelineExecution",
        "codepipeline:GetPipeline",
        "codepipeline:GetPipelineState"
      ],
      "Resource": "arn:aws:codepipeline:us-east-1:338183195778:devops-leonel-pipeline"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::devops-artefacts-leonel-2026/*"
    }
  ]
}
```

---

## ✅ Ce qu'on applique déjà

```
✅ GitHub Secrets : AWS_ACCESS_KEY_ID + AWS_SECRET_ACCESS_KEY (chiffrés)
✅ pip-audit : Scan sécurité dépendances dans le pipeline Jour 12
✅ Tests obligatoires : pytest avant déploiement
✅ Clés supprimées de l'EC2 après usage
✅ IAM User devops-leonel (pas root)
✅ Bucket S3 privé par défaut
```

---

## ➡️ Prochain Jour

[Jour 22 — Créer un Pipeline CI/CD Complet sur AWS](../jour-22-pipeline-cicd-complet/)
