# Jour 26 — Projet Shell : Automatiser la Surveillance AWS 🖥️

> ⏱️ Durée : 45 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif du Projet

Créer un script Shell qui :
- Détecte les services AWS inutilisés (EC2, S3, Lambda, IAM)
- Optimise les coûts en identifiant les ressources non exploitées
- Génère un rapport quotidien automatique
- S'exécute automatiquement via un Cron Job à 18h

---

## 🏗️ Architecture du Projet

```
aws_surveillance.sh
      ↓
  AWS CLI (describe-instances, list-buckets, list-users...)
      ↓
  Fichier rapport : /tmp/rapport-aws-YYYY-MM-DD.txt
      ↓
  Cron Job → Exécution automatique chaque jour à 18h
      ↓
  (Optionnel) Envoi par email via SNS/SES
```

---

## 📋 Services Surveillés

| Service | Ce qu'on vérifie | Alerte si |
|---------|-----------------|-----------|
| **EC2** | Instances et leur état | Instances arrêtées (coût EBS) |
| **S3** | Liste des buckets | Buckets vides inutilisés |
| **IAM** | Utilisateurs | Utilisateurs sans activité |
| **Lambda** | Fonctions | Fonctions non utilisées |
| **Security Groups** | Groupes de sécurité | Groupes non attachés |

---

## 📄 Script Principal

```bash
#!/bin/bash
# aws_surveillance.sh - Surveillance AWS et Rapport Quotidien
# Auteur : Leonel-Magloire PENGOU MBA

set -e

REGION="us-east-1"
RAPPORT="/tmp/rapport-aws-$(date +%Y-%m-%d).txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

log() { echo "$1" | tee -a $RAPPORT; }

# En-tête
log "=== RAPPORT AWS - $DATE ==="

# EC2
log "--- INSTANCES EC2 ---"
aws ec2 describe-instances \
    --region $REGION \
    --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' \
    --output text | tee -a $RAPPORT

# S3
log "--- BUCKETS S3 ---"
aws s3 ls | tee -a $RAPPORT

# IAM
log "--- UTILISATEURS IAM ---"
aws iam list-users \
    --query 'Users[*].[UserName,CreateDate]' \
    --output text | tee -a $RAPPORT

# Lambda
log "--- FONCTIONS LAMBDA ---"
aws lambda list-functions \
    --region $REGION \
    --query 'Functions[*].[FunctionName,Runtime]' \
    --output text | tee -a $RAPPORT

log "=== FIN DU RAPPORT ==="
echo "Rapport : $RAPPORT"
```

---

## ⚙️ Installation et Exécution

```bash
# 1. Copier le script sur l'EC2
scp -i devops-jour3-key.pem aws_surveillance.sh ubuntu@44.222.105.23:~/

# 2. Rendre exécutable
chmod +x ~/aws_surveillance.sh

# 3. Configurer AWS CLI
aws configure set default.region us-east-1

# 4. Tester le script
./aws_surveillance.sh

# 5. Automatiser avec Cron (chaque jour à 18h)
crontab -e
# Ajouter :
# 0 18 * * * /home/ubuntu/aws_surveillance.sh >> /var/log/aws_surveillance.log 2>&1
```

---

## ✅ Preuve d'exécution

```
$ ./aws_surveillance.sh

================================================================
   RAPPORT DE SURVEILLANCE AWS - LEONEL DEVOPS
   Date : 2026-04-01 14:30:00
   Region : us-east-1
================================================================

📦 INSTANCES EC2
─────────────────────────────────────────────
i-0abc123    running    t3.micro    44.222.105.23

🪣 BUCKETS S3
─────────────────────────────────────────────
Total buckets : 1
2026-04-01 devops-artefacts-leonel-2026

👤 UTILISATEURS IAM
─────────────────────────────────────────────
Total utilisateurs : 1
devops-leonel    2026-04-01T10:00:00+00:00

⚡ FONCTIONS LAMBDA
─────────────────────────────────────────────
Aucune fonction Lambda trouvee

================================================================
   RESUME ET RECOMMANDATIONS
================================================================
✅ Rapport genere avec succes
📄 Rapport sauvegarde : /tmp/rapport-aws-2026-04-01.txt
🕐 Prochaine execution : 2026-04-02 18:00:00
================================================================
```

---

## 🕐 Configuration Cron Job

```bash
# Editer le crontab
crontab -e

# Executer chaque jour a 18h
0 18 * * * /home/ubuntu/aws_surveillance.sh >> /var/log/aws_surveillance.log 2>&1

# Verifier le crontab
crontab -l

# Voir les logs
tail -f /var/log/aws_surveillance.log
```

---

## 💰 Optimisation des Coûts

```bash
# Identifier les instances EC2 arrêtées (coût EBS)
aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=stopped" \
    --query 'Reservations[*].Instances[*].[InstanceId,InstanceType]' \
    --output text

# Identifier les volumes EBS non attachés
aws ec2 describe-volumes \
    --filters "Name=status,Values=available" \
    --query 'Volumes[*].[VolumeId,Size,CreateTime]' \
    --output text

# Identifier les IPs Elastic non utilisées (facturées)
aws ec2 describe-addresses \
    --query 'Addresses[?AssociationId==null].[PublicIp,AllocationId]' \
    --output text
```

---

## 🔗 Amélioration — Envoi par Email

```bash
# Envoyer le rapport par email avec AWS SES
aws ses send-email \
    --from "devops@leonel.com" \
    --to "leonelpengou10@gmail.com" \
    --subject "Rapport AWS $(date +%Y-%m-%d)" \
    --text "$(cat $RAPPORT)" \
    --region us-east-1
```

---

## ➡️ Prochain Jour

[Jour 27 — Introduction à Docker](../jour-27-docker-introduction/)
