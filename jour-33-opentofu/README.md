# Jour 33 — OpenTofu : Alternative Open-Source à Terraform 🌍

> ⏱️ Durée : 30 min | 📅 Date : 5 avril 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi OpenTofu existe ?

En 2023, HashiCorp a changé la licence de Terraform de **MPL 2.0** (open source) vers **BUSL** (Business Source License) — ce qui signifie que Terraform n'est **plus vraiment open source** !

```
Terraform v1.5 → MPL 2.0 (Open Source) ✅
Terraform v1.6+ → BUSL (Propriétaire)  ⚠️

Conséquence : Impossible d'utiliser Terraform commercialement
              sans accord avec HashiCorp
```

**OpenTofu** est né comme fork communautaire 100% open source, soutenu par :
```
✅ AWS
✅ Google Cloud
✅ Red Hat
✅ Grafana Labs
✅ Linux Foundation
```

---

## ⚖️ OpenTofu vs Terraform

| Critère | Terraform | OpenTofu |
|---------|-----------|----------|
| **Licence** | BUSL (propriétaire) | MPL 2.0 (open source) |
| **Coût** | Gratuit mais restrictions | 100% gratuit |
| **Compatibilité** | — | ✅ Compatible .tf |
| **Gouvernance** | HashiCorp | Linux Foundation |
| **Communauté** | Fermée | Ouverte |
| **Nouveautés** | HashiCorp décide | Communauté décide |

---

## 📦 Installation OpenTofu

```bash
# Ubuntu/Debian
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sudo bash -s -- --install-method deb

# Vérifier
tofu --version

# macOS
brew install opentofu

# Windows
winget install OpenTofu.OpenTofu
```

---

## 🔄 Migration Terraform → OpenTofu

C'est **ultra simple** — OpenTofu est compatible à 100% avec Terraform !

```bash
# Avant (Terraform)
terraform init
terraform plan
terraform apply

# Après (OpenTofu) - mêmes fichiers .tf !
tofu init
tofu plan
tofu apply
```

**Aucune modification** des fichiers `.tf` nécessaire !

---

## 🚀 Projet Pratique — Notre Infrastructure avec OpenTofu

On réutilise exactement les mêmes fichiers du Jour 32 !

```bash
cd ~/terraform-projet-jour32

# Initialiser avec OpenTofu
tofu init

# Plan
tofu plan

# Résultat identique à Terraform !
# Plan: 2 to add, 0 to change, 0 to destroy
```

---

## 🆕 Fonctionnalités exclusives OpenTofu

### 1. Chiffrement natif du State
```hcl
# Sécuriser terraform.tfstate avec chiffrement AES-GCM
terraform {
  encryption {
    key_provider "pbkdf2" "my_key" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "my_method" {
      keys = key_provider.pbkdf2.my_key
    }
    state {
      method = method.aes_gcm.my_method
    }
  }
}
```

### 2. Functions personnalisées
```hcl
# Créer ses propres functions HCL
function "format_name" {
  params = [name, env]
  result = "${lower(name)}-${lower(env)}"
}

# Utiliser la function
resource "aws_instance" "server" {
  tags = {
    Name = function.format_name("leonel", "prod")
  }
}
```

### 3. Test natif
```bash
# Tester son infrastructure avant de déployer
tofu test
```

---

## 📁 Structure Backend Distant (S3)

Pour stocker le state dans S3 (équipe) :

```hcl
# providers.tf
terraform {
  backend "s3" {
    bucket = "devops-artefacts-leonel-2026"
    key    = "terraform/state/leonel-devops.tfstate"
    region = "us-east-1"
  }
}
```

```bash
# Initialiser avec backend S3
tofu init

# Le state est maintenant partagé dans S3 !
aws s3 ls s3://devops-artefacts-leonel-2026/terraform/
```

---

## 🌍 Qui utilise OpenTofu en production ?

```
✅ Spotify       → Migration depuis Terraform
✅ Cloudflare    → Infrastructure as Code
✅ Grafana Labs  → Contributeur actif
✅ env0          → Platform DevOps
✅ Spacelift     → CI/CD Terraform/OpenTofu
```

---

## 🔮 Roadmap OpenTofu vs Terraform

```
OpenTofu 1.8 → Functions personnalisées ✅
OpenTofu 1.9 → Chiffrement du state     ✅
OpenTofu 2.0 → Tests améliorés          🔄

Terraform 1.9  → Nouvelles fonctionnalités BUSL
Terraform 1.10 → Disponible seulement via HCP
```

---

## ✅ Notre Stack IaC

```
Jour 31 → Terraform : Introduction + concepts HCL
Jour 32 → Terraform : Plan 2 to add (EC2 + Security Group)
Jour 33 → OpenTofu  : Alternative open source compatible

Commande commune :
  tofu/terraform init   ✅
  tofu/terraform plan   ✅ Plan: 2 to add
  tofu/terraform apply  → Déploiement réel
```

---

## ➡️ Prochain Jour

[Jour 34 — Architecture Serverless et AWS Lambda](../jour-34-serverless-lambda/)
