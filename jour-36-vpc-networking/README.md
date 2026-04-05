# Jour 36 — AWS VPC & Networking : Subnetting, Sécurité & Optimisation 🌐

> ⏱️ Durée : 45 min | 📅 Date : 5 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Comprendre et configurer un VPC AWS complet avec subnets publics et privés, Security Groups, NACLs, Internet Gateway et NAT Gateway.

---

## 🌐 C'est quoi un VPC ?

```
VPC = Virtual Private Cloud
→ Votre réseau privé isolé dans AWS
→ Vous contrôlez tout : IPs, routage, sécurité

Sans VPC :                    Avec VPC :
Toutes les ressources         Ressources isolées dans
accessibles publiquement  →   votre réseau privé sécurisé
```

---

## 📐 CIDR et Subnetting

### Notation CIDR
```
10.0.0.0/16  → 65 536 adresses IP disponibles  (VPC entier)
10.0.1.0/24  → 256 adresses IP disponibles     (Subnet)
10.0.1.0/28  → 16 adresses IP disponibles      (Petit subnet)
```

### Notre VPC de la formation
```
VPC CIDR     : 10.0.0.0/16
Region       : us-east-1

Subnets Publics (accès Internet) :
  10.0.1.0/24  → us-east-1a (Public Subnet 1)
  10.0.2.0/24  → us-east-1b (Public Subnet 2)

Subnets Privés (pas d'accès Internet direct) :
  10.0.3.0/24  → us-east-1a (Private Subnet 1)
  10.0.4.0/24  → us-east-1b (Private Subnet 2)
```

---

## 🏗️ Architecture VPC Complète

```
Internet
    ↓
Internet Gateway (IGW)
    ↓
┌─────────────────────────────────────────┐
│                   VPC                   │
│           10.0.0.0/16                   │
│                                         │
│  ┌──────────────┐  ┌──────────────┐    │
│  │Public Subnet │  │Public Subnet │    │
│  │ 10.0.1.0/24  │  │ 10.0.2.0/24  │    │
│  │   EC2 Web    │  │   EC2 Web    │    │
│  └──────┬───────┘  └──────┬───────┘    │
│         │                 │             │
│       NAT GW            NAT GW          │
│         │                 │             │
│  ┌──────▼───────┐  ┌──────▼───────┐    │
│  │Private Subnet│  │Private Subnet│    │
│  │ 10.0.3.0/24  │  │ 10.0.4.0/24  │    │
│  │   EC2 App    │  │   RDS DB     │    │
│  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────┘
```

---

## 🔐 Security Groups vs NACLs

| Critère | Security Group | NACL |
|---------|---------------|------|
| **Niveau** | Instance EC2 | Subnet |
| **Type** | Stateful | Stateless |
| **Règles** | Allow seulement | Allow + Deny |
| **Évaluation** | Toutes les règles | Par ordre de priorité |
| **Usage** | Firewall instance | Firewall subnet |

### Security Group — Notre EC2
```
Inbound Rules :
  Port 22   (SSH)  → 0.0.0.0/0
  Port 80   (HTTP) → 0.0.0.0/0
  Port 443  (HTTPS)→ 0.0.0.0/0

Outbound Rules :
  All traffic → 0.0.0.0/0
```

### NACL — Subnet Public
```
Inbound Rules :
  100 : HTTP  (80)  → ALLOW 0.0.0.0/0
  110 : HTTPS (443) → ALLOW 0.0.0.0/0
  120 : SSH   (22)  → ALLOW 0.0.0.0/0
  *   : ALL         → DENY

Outbound Rules :
  100 : ALL → ALLOW 0.0.0.0/0
  *   : ALL → DENY
```

---

## 🌍 Internet Gateway vs NAT Gateway

### Internet Gateway (IGW)
```
→ Permet aux ressources PUBLIQUES d'accéder à Internet
→ Gratuit
→ Attaché au VPC

Subnet Public → Route Table → IGW → Internet
```

### NAT Gateway
```
→ Permet aux ressources PRIVÉES d'accéder à Internet
→ Payant : ~0.045$/heure + 0.045$/GB
→ Placé dans un subnet public

Subnet Privé → NAT GW → IGW → Internet
(mais Internet ne peut pas initier la connexion)
```

---

## ⚖️ Load Balancer — ALB vs NLB

| Critère | ALB | NLB |
|---------|-----|-----|
| **Couche OSI** | Layer 7 (HTTP/HTTPS) | Layer 4 (TCP/UDP) |
| **Routage** | URL, headers, cookies | IP, port |
| **Usage** | Applications web | Haute performance |
| **Latence** | Normale | Ultra-faible |
| **Prix** | Normal | Plus cher |

---

## 🚀 Créer un VPC avec AWS CLI

```bash
# 1. Créer le VPC
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --query 'Vpc.VpcId' \
    --output text)
echo "VPC créé : $VPC_ID"

# 2. Créer les subnets publics
SUBNET_PUB_1=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.1.0/24 \
    --availability-zone us-east-1a \
    --query 'Subnet.SubnetId' \
    --output text)

# 3. Créer l'Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)

# 4. Attacher l'IGW au VPC
aws ec2 attach-internet-gateway \
    --vpc-id $VPC_ID \
    --internet-gateway-id $IGW_ID

# 5. Créer la Route Table publique
RT_ID=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --query 'RouteTable.RouteTableId' \
    --output text)

# 6. Ajouter la route vers Internet
aws ec2 create-route \
    --route-table-id $RT_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $IGW_ID

echo "VPC configuré !"
echo "VPC ID : $VPC_ID"
echo "IGW ID : $IGW_ID"
```

---

## 💰 Optimisation des Coûts VPC

```
NAT Gateway    → 0.045$/heure = ~32$/mois par AZ
               → Utiliser 1 seul NAT GW pour dev/test

IPs Elastiques → 0.005$/heure si non utilisées
               → Libérer immédiatement après usage

Data Transfer  → Gratuit dans la même AZ
               → Payant entre AZs (0.01$/GB)
               → Utiliser des endpoints VPC pour S3/DynamoDB
```

---

## ✅ Notre VPC existant

```
Notre instance EC2 actuelle :
  IP publique  : 44.222.105.23
  IP privée    : 172.31.78.7
  VPC          : vpc-default (VPC par défaut AWS)
  Subnet       : subnet public us-east-1
  Security Group: port 22 + 80 ouverts
```

---

## ➡️ Prochain Jour

[Jour 37 — Pratique AWS VPC avec 4 Subnets (2 Publics & 2 Privés)](../jour-37-vpc-pratique/)
