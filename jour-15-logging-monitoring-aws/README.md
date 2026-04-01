# Jour 15 — Logging et Monitoring avec AWS (Partie 2) 📊

> ⏱️ Durée : 23 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Approfondir CloudWatch Logs et CloudTrail pour surveiller, analyser et sécuriser ton infrastructure AWS en production.

---

## 📋 AWS CloudWatch Logs — Analyse Avancée

### Flux de logs
```
EC2 / Lambda / CodeBuild / ECS
         ↓
   CloudWatch Agent
         ↓
   Log Group (organisation)
         ↓
   Log Stream (source spécifique)
         ↓
   Log Events (entrées individuelles)
```

### Créer un filtre de métriques
```
CloudWatch → Log Groups → Ton Log Group
→ Metric Filters → Create Metric Filter

Pattern : [timestamp, level="ERROR", message]
Metric : nombre d'erreurs par minute
Alarme : si > 5 erreurs → alerte SNS
```

### Exporter les logs vers S3
```
CloudWatch → Log Groups → Actions → Export data to S3
  ├── Bucket : devops-artefacts-leonel-2026
  ├── Prefix : logs/cloudwatch/
  └── Date range : choisir la période
```

---

## 🔍 CloudTrail Avancé

### Suivi des changements de ressources
```
CloudTrail Events → Filter par :
  ├── Event name  : RunInstances, TerminateInstances
  ├── Resource    : EC2, S3, IAM
  ├── User        : devops-leonel
  └── Time range  : dernières 24h
```

### Événements importants à surveiller
| Événement | Description | Risque |
|-----------|-------------|--------|
| `ConsoleLogin` | Connexion console | Tentatives suspectes |
| `DeleteBucket` | Suppression S3 | Perte de données |
| `AuthorizeSecurityGroupIngress` | Ouverture port | Sécurité réseau |
| `CreateAccessKey` | Nouvelle clé IAM | Compromission compte |
| `StopInstances` | Arrêt EC2 | Interruption service |

---

## 📈 Métriques Clés à Surveiller

### EC2
```
CPUUtilization      → Seuil : > 80%
NetworkIn/Out       → Trafic réseau
DiskReadOps         → Lectures disque
StatusCheckFailed   → Instance en erreur
```

### CodeBuild
```
SucceededBuilds     → Builds réussis
FailedBuilds        → Builds échoués
Duration            → Durée moyenne
```

### S3
```
BucketSizeBytes     → Taille du bucket
NumberOfObjects     → Nombre d'objets
AllRequests         → Requêtes totales
```

---

## 🚨 Créer une Alarme CloudWatch

```
CloudWatch → Alarms → Create Alarm
  ↓
1. Select metric
   EC2 → Per-Instance Metrics → CPUUtilization
  ↓
2. Conditions
   Threshold : Greater than 80%
   Period : 5 minutes
  ↓
3. Actions
   Send notification to SNS topic
   → Email : leonelpengou10@gmail.com
  ↓
4. Name
   ec2-cpu-high-alarm
```

---

## 🔗 Intégration avec ELK Stack et SIEM

```
CloudWatch Logs
      ↓
  Kinesis Data Firehose
      ↓
  Elasticsearch / OpenSearch
      ↓
  Kibana (visualisation)
      ↓
  SIEM (Security Information and Event Management)
```

---

## 🛡️ Security Monitoring — Bonnes Pratiques

```
✅ Activer CloudTrail dans TOUTES les régions
✅ Activer la validation des fichiers de log
✅ Envoyer les logs vers un bucket S3 dédié
✅ Créer des alarmes pour les actions critiques IAM
✅ Configurer des alertes pour les connexions anormales
✅ Conserver les logs minimum 90 jours
✅ Utiliser AWS Config pour l'audit de configuration
```

---

## ✅ Preuve — Monitoring de notre infrastructure

```
Bucket S3 actif     : devops-artefacts-leonel-2026 ✅
Site déployé        : site/index.html (2040 bytes) ✅
Pipeline CI/CD      : GitHub Actions → S3 ✅
IAM User créé       : devops-leonel (AdministratorAccess) ✅
Clés AWS sécurisées : GitHub Secrets (chiffré) ✅
EC2 monitoré        : ip-172-31-78-7 (us-east-1) ✅

Métriques pipeline :
  Jour 12 : 20s build → SUCCESS ✅
  Jour 13 : 14s deploy → SUCCESS ✅
```

---

## ➡️ Prochain Jour

[Jour 16 — Introduction à AWS CodeDeploy](../jour-16-aws-codedeploy/)
