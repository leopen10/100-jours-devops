# Jour 40 — Questions d'Entretien AWS : Scénarios Réels EC2, IAM & VPC 🎯

> ⏱️ Durée : 45 min | 📅 Date : 5 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Préparer les questions d'entretien techniques posées lors de vrais entretiens DevOps Engineer AWS, basées sur des scénarios réels.

---

## 🏗️ Architecture VPC — Questions Entretien

### Q1. Comment concevoir un VPC hautement disponible ?
```
✅ Réponse :
- VPC avec CIDR /16 (65 536 IPs)
- Minimum 2 AZs (us-east-1a + us-east-1b)
- 1 subnet public + 1 subnet privé par AZ
- Internet Gateway pour les subnets publics
- NAT Gateway dans chaque AZ pour les subnets privés
- Route Tables séparées : public → IGW, privé → NAT GW
- ALB sur les subnets publics
- EC2 dans les subnets privés

Architecture :
  Internet → IGW → ALB (Public) → EC2 (Privé) → RDS (Privé)
```

### Q2. Comment restreindre l'accès à Internet par subnet ?
```
✅ Réponse :
Subnet Public  → Route Table avec 0.0.0.0/0 → IGW
Subnet Privé   → Route Table SANS route vers IGW
               → Uniquement route locale (10.0.0.0/16)
               → Pour sortir vers Internet : NAT Gateway

Double sécurité : NACL + Security Group
  NACL  : Firewall au niveau subnet (Stateless)
  SG    : Firewall au niveau instance (Stateful)
```

### Q3. Différence entre NAT Gateway et Internet Gateway ?
```
Internet Gateway (IGW) :
  → Permet aux instances PUBLIQUES d'accéder à Internet
  → Bidirectionnel : Internet peut initier la connexion
  → Gratuit

NAT Gateway :
  → Permet aux instances PRIVÉES d'accéder à Internet
  → Unidirectionnel : Internet ne peut PAS initier
  → Payant : ~0.045$/heure + 0.045$/GB
  → Placé dans un subnet public
  → Haute disponibilité dans une AZ
```

### Q4. C'est quoi un Bastion Host (Jump Server) ?
```
✅ Réponse :
Instance EC2 dans un subnet PUBLIC qui sert de point d'entrée
sécurisé pour accéder aux instances PRIVÉES.

Architecture :
  Mon PC → SSH → Bastion Host (Public) → SSH → EC2 Privée

Configuration :
  Bastion SG : Port 22 ouvert depuis mon IP uniquement
  EC2 SG     : Port 22 ouvert depuis le Bastion SG uniquement

Commande :
  # Connexion via Bastion
  ssh -J ubuntu@bastion-ip ubuntu@private-ec2-ip
```

### Q5. Comment accéder à S3 depuis un subnet privé sans Internet ?
```
✅ Réponse : VPC Endpoint (Gateway Endpoint pour S3)

Sans VPC Endpoint :
  EC2 Privée → NAT GW → Internet → S3 (coût + latence)

Avec VPC Endpoint :
  EC2 Privée → VPC Endpoint → S3 (gratuit + sécurisé)

Configuration :
  aws ec2 create-vpc-endpoint \
    --vpc-id vpc-xxx \
    --service-name com.amazonaws.us-east-1.s3 \
    --route-table-ids rtb-xxx
```

---

## 🔐 IAM — Questions Entretien

### Q6. Différence entre IAM User, Group, Role et Policy ?
```
IAM User   : Identité permanente pour une personne/application
             → Credentials = Access Key + Secret Key

IAM Group  : Regroupement d'utilisateurs
             → Attacher des policies à un groupe plutôt qu'aux users

IAM Role   : Identité temporaire assumée par un service
             → EC2 → AssumeRole → accès S3 sans credentials
             → Credentials temporaires (STS)

IAM Policy : Document JSON définissant les permissions
             → Managed Policy : réutilisable
             → Inline Policy  : attachée à une seule entité
```

### Q7. Comment sécuriser l'accès à une instance EC2 ?
```
✅ Réponse :
1. IAM Instance Profile → Role attaché à l'EC2 (pas de Access Keys)
2. Security Group       → Restreindre les ports et sources
3. Clé SSH ED25519     → Plus sécurisée que RSA
4. Bastion Host        → Pas d'accès direct SSH depuis Internet
5. VPC Privé           → Instance dans subnet privé
6. CloudTrail          → Audit de toutes les actions
7. SSM Session Manager → SSH sans port 22 ouvert !
```

### Q8. Qu'est-ce que le principe du moindre privilège ?
```
✅ Réponse :
Donner UNIQUEMENT les permissions nécessaires pour effectuer
une tâche spécifique — ni plus, ni moins.

Mauvais exemple :
  aws iam attach-role-policy --policy-arn AdministratorAccess

Bon exemple :
  Policy personnalisée :
  {
    "Effect": "Allow",
    "Action": ["s3:GetObject", "s3:PutObject"],
    "Resource": "arn:aws:s3:::mon-bucket/*"
  }
```

---

## 🖥️ EC2 — Questions Entretien

### Q9. Différence entre Stop, Terminate et Reboot ?
```
Stop      : Instance arrêtée, données EBS conservées
            → Facturation EBS continue, EC2 arrêtée
            → IP publique perdue (sauf Elastic IP)

Terminate : Instance supprimée définitivement
            → Volume EBS racine supprimé par défaut
            → Données perdues !

Reboot    : Redémarrage, même IP, données conservées
            → Comme un reboot Linux normal
```

### Q10. Comment rendre une architecture EC2 hautement disponible ?
```
✅ Réponse :
1. Multi-AZ           : EC2 dans 2+ zones de disponibilité
2. Auto Scaling Group : Min/Max/Desired instances
3. ALB                : Load Balancer devant les EC2
4. Health Checks      : Supprimer les instances malades
5. Launch Template    : Recréer des instances identiques

Notre Jour 39 :
  ASG : Min=1, Max=3, Desired=1
  Multi-AZ : us-east-1a + us-east-1b
```

---

## 🔒 NACL vs Security Group — Question Clé

### Q11. Quand utiliser NACL vs Security Group ?
```
Security Group (SG) :
  ✅ Niveau instance EC2
  ✅ Stateful (réponse automatique autorisée)
  ✅ Règles Allow uniquement
  ✅ Évalue TOUTES les règles
  → Utiliser pour : contrôle fin par instance

NACL :
  ✅ Niveau subnet
  ✅ Stateless (règles entrée ET sortie obligatoires)
  ✅ Règles Allow ET Deny
  ✅ Évalue par ordre de priorité (numéro)
  → Utiliser pour : bloquer une IP malveillante rapidement

Exemple pratique :
  IP attaque : 192.168.1.100
  NACL Rule 50 : DENY 192.168.1.100/32 ALL → bloquée !
```

---

## ✅ Nos Preuves dans la Formation

```
EC2  : Instance t3.micro Ubuntu en production depuis Jour 3
       http://44.222.105.23 - LEONEL INVOICE SYSTEM

IAM  : devops-leonel + LambdaSnapshotRole + CodeDeployRole
       Créés et configurés Jours 9, 19, 35

VPC  : VPC custom créé Jours 36, 37, 39
       vpc-0de5ba301ab5b733b, vpc-0e5cb020733c81e12,
       vpc-08f197056c4a9bae1

ASG  : Auto Scaling Group créé Jour 39
       leonel-asg-jour39 : Min=1, Max=3, Multi-AZ
```

---

## ➡️ Prochain Jour

[Jour 41 — AWS CloudFormation : Créez votre infrastructure avec du code](../jour-41-cloudformation/)
