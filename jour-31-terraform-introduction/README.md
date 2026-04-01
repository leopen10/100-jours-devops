# Jour 31 — Introduction à Terraform et Infrastructure as Code 🏗️

> ⏱️ Durée : 35 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🚨 Problèmes du Déploiement Manuel

```
AWS CLI    → Scripts Bash AWS
Azure      → ARM Templates
GCP        → gcloud commands
OpenStack  → Heat Templates

Problème : 4 outils différents, 4 langages différents !
Migration AWS → Azure = réécriture complète des scripts
```

---

## 🛠️ Terraform — La Solution

**Un seul langage (HCL) pour gérer tous les clouds !**

```
Terraform HCL
      ↓
┌─────────────────────────────────┐
│  AWS  │  Azure  │  GCP  │  K8s │
└─────────────────────────────────┘
```

### Avantages
```
✅ Multi-cloud : AWS + Azure + GCP + on-premise
✅ Idempotent  : Appliquer 100 fois = même résultat
✅ Plan avant Apply : Voir les changements avant de les appliquer
✅ State       : Terraform mémorise l'état de l'infrastructure
✅ Modules     : Code réutilisable
✅ Open Source : Communauté massive
```

---

## 📄 Langage HCL — HashiCorp Configuration Language

### Structure de base
```hcl
# main.tf - Configuration principale

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "mon_serveur" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 24.04
  instance_type = "t3.micro"

  tags = {
    Name = "devops-leonel-terraform"
    Env  = "production"
  }
}
```

---

## 🔄 Workflow Terraform

```
1. terraform init     → Télécharger les providers
2. terraform plan     → Voir les changements (sans appliquer)
3. terraform apply    → Appliquer les changements
4. terraform destroy  → Supprimer l'infrastructure
```

### Terraform Plan — Exemple de sortie
```
Plan: 1 to add, 0 to change, 0 to destroy.

+ resource "aws_instance" "mon_serveur" {
  + ami           = "ami-0c7217cdde317cfec"
  + instance_type = "t3.micro"
  + tags = {
    + Name = "devops-leonel-terraform"
  }
}
```

---

## 📦 Concepts Clés

### Provider
```hcl
# Connecteur vers AWS, Azure, GCP...
provider "aws" {
  region = "us-east-1"
}
```

### Resource
```hcl
# Une ressource AWS à créer
resource "aws_s3_bucket" "mon_bucket" {
  bucket = "devops-leonel-terraform-2026"
}
```

### Variable
```hcl
# Variables réutilisables
variable "region" {
  description = "Region AWS"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type EC2"
  default     = "t3.micro"
}
```

### Output
```hcl
# Afficher des valeurs après apply
output "ip_publique" {
  value = aws_instance.mon_serveur.public_ip
}

output "url_site" {
  value = "http://${aws_instance.mon_serveur.public_ip}"
}
```

### Data Source
```hcl
# Lire des données existantes
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-24.04-amd64-server-*"]
  }
}
```

---

## 🏗️ Terraform vs Ansible vs CloudFormation

| Critère | Terraform | Ansible | CloudFormation |
|---------|-----------|---------|----------------|
| **Type** | IaC Provisioning | Configuration Mgmt | IaC AWS seulement |
| **Multi-cloud** | ✅ Oui | ✅ Oui | ❌ AWS uniquement |
| **Langage** | HCL | YAML | JSON/YAML |
| **State** | ✅ Fichier tfstate | ❌ Non | ✅ AWS Stack |
| **Idempotent** | ✅ Oui | ✅ Oui | ✅ Oui |
| **Usage** | Créer infra | Configurer serveurs | Créer infra AWS |

**En pratique :** Terraform + Ansible = combo parfait !
- Terraform crée l'infrastructure (EC2, VPC, S3...)
- Ansible configure les serveurs (installer Nginx, Django...)

---

## 📁 Structure d'un Projet Terraform

```
mon-projet-terraform/
├── main.tf           ← Ressources principales
├── variables.tf      ← Déclaration des variables
├── outputs.tf        ← Valeurs à afficher
├── providers.tf      ← Configuration des providers
├── terraform.tfvars  ← Valeurs des variables
└── modules/
    ├── ec2/
    │   └── main.tf   ← Module EC2 réutilisable
    └── vpc/
        └── main.tf   ← Module VPC réutilisable
```

---

## 🚀 Exemple Complet — Notre Infrastructure

```hcl
# main.tf - Recréer notre EC2 avec Terraform

provider "aws" {
  region = var.region
}

resource "aws_security_group" "devops_sg" {
  name = "devops-leonel-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_server" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = var.instance_type
  key_name               = "devops-jour3-key"
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "leonel-devops-terraform"
    Env  = "production"
    Jour = "31"
  }
}

output "ip_publique" {
  value = aws_instance.devops_server.public_ip
}
```

---

## ✅ Terraform State

```
terraform.tfstate ← Fichier qui mémorise l'infrastructure créée

Contient :
  - ID des ressources créées
  - Configuration actuelle
  - Métadonnées

IMPORTANT : Ne jamais commiter terraform.tfstate sur GitHub !
Ajouter .terraform et terraform.tfstate dans .gitignore
```

---

## ➡️ Prochain Jour

[Jour 32 — Terraform Complet : Projet Réel, Modules et Backend Distant](../jour-32-terraform-projet-reel/)
