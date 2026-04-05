# Jour 35 — Optimisation des Coûts Cloud avec AWS Lambda & Boto3 💰

> ⏱️ Durée : 50 min | 📅 Date : 5 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Automatiser la suppression des ressources AWS inutilisées pour réduire les coûts cloud, en utilisant AWS Lambda + Boto3 (SDK Python pour AWS).

---

## 💸 Pourquoi Optimiser les Coûts AWS ?

```
Snapshots EBS oubliés       → Facturés 0.05$/GB/mois
Volumes EBS non attachés    → Facturés 0.10$/GB/mois
IPs Elastic non utilisées   → Facturés 0.005$/heure
Instances arrêtées          → EBS facturé quand même !

Exemple : 100 snapshots × 20 GB × 0.05$ = 100$/mois gaspillés !
```

---

## 🤖 Boto3 — SDK Python pour AWS

```python
# Installation
pip install boto3

# Configuration
import boto3

# Client EC2
ec2 = boto3.client('ec2', region_name='us-east-1')

# Resource EC2 (interface plus haut niveau)
ec2_resource = boto3.resource('ec2', region_name='us-east-1')
```

---

## 🚀 Projet Principal — Supprimer les Snapshots EBS Inutilisés

```python
# lambda_function.py
import boto3

def lambda_handler(event, context):
    """
    Lambda Jour 35 - Supprimer les snapshots EBS inutilises
    Auteur : Leonel-Magloire PENGOU MBA
    Declencheur : CloudWatch Events (Cron mensuel)
    """
    ec2 = boto3.client('ec2', region_name='us-east-1')
    
    # 1. Recuperer notre Account ID
    account_id = boto3.client('sts').get_caller_identity()['Account']
    
    # 2. Lister tous nos snapshots
    snapshots = ec2.describe_snapshots(
        OwnerIds=[account_id]
    )['Snapshots']
    
    print(f"Total snapshots trouves : {len(snapshots)}")
    
    # 3. Lister tous les volumes actifs
    volumes_actifs = set()
    volumes = ec2.describe_volumes()['Volumes']
    for volume in volumes:
        volumes_actifs.add(volume['VolumeId'])
    
    # 4. Lister les AMIs utilisees
    amis = ec2.describe_images(Owners=[account_id])['Images']
    snapshots_amis = set()
    for ami in amis:
        for mapping in ami.get('BlockDeviceMappings', []):
            snap_id = mapping.get('Ebs', {}).get('SnapshotId')
            if snap_id:
                snapshots_amis.add(snap_id)
    
    # 5. Supprimer les snapshots inutilises
    supprimes = 0
    gardes = 0
    
    for snapshot in snapshots:
        snap_id = snapshot['SnapshotId']
        volume_id = snapshot.get('VolumeId', '')
        
        # Garder si associe a une AMI
        if snap_id in snapshots_amis:
            print(f"GARDE (AMI) : {snap_id}")
            gardes += 1
            continue
        
        # Garder si le volume existe encore
        if volume_id and volume_id in volumes_actifs:
            print(f"GARDE (Volume actif) : {snap_id}")
            gardes += 1
            continue
        
        # Supprimer les snapshots orphelins
        try:
            ec2.delete_snapshot(SnapshotId=snap_id)
            print(f"SUPPRIME : {snap_id} (Volume: {volume_id})")
            supprimes += 1
        except Exception as e:
            print(f"ERREUR suppression {snap_id} : {str(e)}")
    
    # 6. Rapport final
    rapport = {
        'total_snapshots': len(snapshots),
        'supprimes': supprimes,
        'gardes': gardes,
        'economie_estimee': f"{supprimes * 1}$/mois (estimation)"
    }
    
    print(f"\n=== RAPPORT FINAL ===")
    print(f"Total    : {rapport['total_snapshots']}")
    print(f"Supprimés: {rapport['supprimes']}")
    print(f"Gardés   : {rapport['gardes']}")
    print(f"Économie : {rapport['economie_estimee']}")
    
    return rapport
```

---

## ⚙️ Configuration Lambda sur AWS

```
Runtime  : Python 3.12
Mémoire  : 128 MB (suffisant)
Timeout  : 5 minutes
Role IAM : LambdaEC2SnapshotRole

Permissions IAM nécessaires :
  - ec2:DescribeSnapshots
  - ec2:DeleteSnapshot
  - ec2:DescribeVolumes
  - ec2:DescribeImages
  - sts:GetCallerIdentity
```

---

## 🕐 Automatisation — CloudWatch Events (Cron)

```
# Déclencheur : 1er de chaque mois à 8h UTC
cron(0 8 1 * ? *)

# Ou toutes les semaines le lundi
cron(0 8 ? * MON *)
```

---

## 🔔 Trigger vs Destination dans Lambda

### Add a Trigger (Entrée)
```
Déclencheurs → Lambda
─────────────────────
API Gateway  → HTTP request
S3           → Upload fichier
CloudWatch   → Cron job
SNS          → Notification reçue
SQS          → Message en file
DynamoDB     → Changement en BDD
```

### Add a Destination (Sortie)
```
Lambda → Destination
────────────────────
Lambda → SNS  → Email/SMS (succès ou échec)
Lambda → SQS  → File de messages
Lambda → S3   → Sauvegarder le résultat
Lambda → EventBridge → Autre service
```

---

## 📊 SNS vs SQS — Comparaison

| Critère | SNS | SQS |
|---------|-----|-----|
| **Type** | Push (notification) | Pull (file d'attente) |
| **Modèle** | Pub/Sub | Queue |
| **Destinataires** | Multiples | Un seul consommateur |
| **Persistance** | Non | Oui (jusqu'à 14 jours) |
| **Usage Lambda** | Notifier après exécution | Déclencher Lambda depuis file |
| **Exemple** | Email d'alerte | Traitement de commandes |

---

## 🔧 Autres Scripts Boto3 d'Optimisation

### Arrêter les instances EC2 non taguées
```python
def arreter_instances_non_taguees():
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(
        Filters=[{'Name': 'instance-state-name', 'Values': ['running']}]
    )
    
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            tags = {t['Key']: t['Value'] for t in instance.get('Tags', [])}
            if 'Env' not in tags:
                ec2.stop_instances(InstanceIds=[instance['InstanceId']])
                print(f"Instance arretee : {instance['InstanceId']}")
```

### Supprimer les volumes EBS non attachés
```python
def supprimer_volumes_non_attaches():
    ec2 = boto3.client('ec2')
    volumes = ec2.describe_volumes(
        Filters=[{'Name': 'status', 'Values': ['available']}]
    )['Volumes']
    
    for volume in volumes:
        print(f"Suppression volume : {volume['VolumeId']} ({volume['Size']}GB)")
        ec2.delete_volume(VolumeId=volume['VolumeId'])
```

### Libérer les IPs Elastic non utilisées
```python
def liberer_ips_elastiques():
    ec2 = boto3.client('ec2')
    addresses = ec2.describe_addresses()['Addresses']
    
    for addr in addresses:
        if 'AssociationId' not in addr:
            ec2.release_address(AllocationId=addr['AllocationId'])
            print(f"IP liberee : {addr['PublicIp']}")
```

---

## ✅ Lien avec notre Formation

```
Jour 26 → Script Shell surveillance AWS (EC2, S3, IAM)
Jour 35 → Lambda + Boto3 surveillance AWS (version Serverless !)

Avant :
  Cron Job EC2 → aws_surveillance.sh → rapport texte

Après :
  CloudWatch Events → Lambda → Boto3 → rapport + suppression auto
  + SNS → Email notification
  + Pas de serveur à gérer !
```

---

## ➡️ Prochain Jour

[Jour 36 — AWS VPC & Networking : Subnetting, Sécurité & Optimisation](../jour-36-vpc-networking/)
