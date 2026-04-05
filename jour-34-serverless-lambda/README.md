# Jour 34 — C'est quoi une Architecture Serverless ? 🚀

> ⏱️ Durée : 25 min | 📅 Date : 5 avril 2026 | ✅ Statut : Complété

---

## 🎯 C'est quoi le Serverless ?

**Serverless** ne veut pas dire "pas de serveur" — ça veut dire **tu ne gères plus les serveurs !**

```
Architecture Traditionnelle        Architecture Serverless
──────────────────────────         ───────────────────────
EC2 t3.micro → payer 24h/24   →   Lambda → payer seulement quand ça tourne
Gérer OS, patches, scaling    →   AWS gère tout automatiquement
Capacité fixe                 →   Scale automatique 0 → infini
Disponibilité à configurer    →   Haute dispo par défaut
```

---

## ⚡ AWS Lambda — Le service Serverless phare

### Principe
```
Événement → Lambda → Réponse

Événement = API Gateway, S3, DynamoDB, SNS, SQS, CloudWatch...
Lambda    = Ton code Python/Node.js/Java/Go/Ruby
```

### Facturation
```
Gratuit :    1 million d'invocations/mois
             400 000 GB-secondes/mois

Après :      0.20$ par million d'invocations
             0.0000166667$ par GB-seconde
```

### Limites
```
Timeout max  : 15 minutes
Mémoire max  : 10 GB
Taille code  : 50 MB (zippé), 250 MB (décompressé)
Concurrence  : 1000 par défaut (augmentable)
```

---

## 📝 Premier Lambda — Python

```python
# lambda_function.py
import json
import boto3
from datetime import datetime

def lambda_handler(event, context):
    """
    Fonction Lambda - Leonel DevOps
    Déclenché par : API Gateway, S3, etc.
    """
    print(f"Event reçu : {json.dumps(event)}")
    
    # Récupérer les paramètres
    nom = event.get('nom', 'DevOps')
    
    # Logique métier
    message = f"Bonjour {nom} ! Il est {datetime.now().strftime('%H:%M:%S')}"
    
    # Retourner une réponse HTTP
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'message': message,
            'auteur': 'Leonel-Magloire PENGOU MBA'
        })
    }
```

---

## 🏗️ Architectures Serverless Courantes

### 1. API REST Serverless
```
Client
  ↓
API Gateway (REST API)
  ↓
Lambda (Python/Node.js)
  ↓
DynamoDB (Base NoSQL)
```

### 2. Pipeline de traitement de fichiers
```
S3 (upload fichier)
  ↓
Lambda (trigger S3)
  ↓
Traitement (resize image, parse CSV...)
  ↓
S3 (fichier traité)
```

### 3. Surveillance automatique
```
CloudWatch Events (Cron)
  ↓
Lambda (script surveillance)
  ↓
SNS (notification email/SMS)
```

---

## ⚖️ Serverless vs EC2 — Quand choisir quoi ?

| Critère | EC2 | Lambda |
|---------|-----|--------|
| **Tâches longues** | ✅ Illimité | ❌ 15 min max |
| **Coût faible trafic** | ❌ Payer 24h/24 | ✅ Payer à l'usage |
| **Scaling** | ⚙️ Manual/Auto | ✅ Automatique |
| **Contrôle OS** | ✅ Total | ❌ Aucun |
| **Cold Start** | ✅ Aucun | ⚠️ Quelques ms |
| **Déploiement** | CI/CD complet | Simple zip |
| **Cas d'usage** | App web, BDD | Events, APIs, Cron |

---

## 🚀 Lambda dans notre Formation

### Equivalent de notre Cron Job Shell
```python
# Avant : Cron Job sur EC2 (Jour 26)
# 0 18 * * * /home/ubuntu/aws_surveillance.sh

# Après : Lambda + CloudWatch Events
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='us-east-1')
    s3 = boto3.client('s3')
    iam = boto3.client('iam')
    
    # Lister les instances EC2
    instances = ec2.describe_instances()
    
    # Lister les buckets S3
    buckets = s3.list_buckets()
    
    # Générer rapport
    rapport = {
        'ec2': len(instances['Reservations']),
        's3': len(buckets['Buckets']),
        'date': str(datetime.now())
    }
    
    print(f"Rapport AWS : {rapport}")
    return rapport
```

---

## 🔧 Services Serverless AWS complémentaires

```
AWS Lambda        → Code serverless
API Gateway       → Exposer Lambda en API REST
DynamoDB          → Base NoSQL serverless
S3                → Stockage serverless
SNS               → Notifications serverless
SQS               → Files de messages serverless
Step Functions    → Orchestration Lambda
EventBridge       → Bus d'événements serverless
CloudWatch Events → Cron Jobs serverless
```

---

## ✅ Avantages clés du Serverless

```
✅ Pas de gestion de serveur
✅ Scaling automatique (0 → infini)
✅ Paiement à l'usage uniquement
✅ Haute disponibilité par défaut
✅ Déploiement simplifié
✅ Focus sur le code métier
```

---

## ➡️ Prochain Jour

[Jour 35 — Optimisation des Coûts Cloud avec AWS Lambda et Boto3](../jour-35-lambda-boto3/)
