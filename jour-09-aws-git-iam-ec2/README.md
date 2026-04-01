# Jour 09 — Déploiement d'un Premier Projet sur AWS avec Git, GitHub, IAM et EC2 ☁️

> ⏱️ Durée : 1h04 | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Déployer un projet réel sur AWS en combinant IAM, EC2, Git et GitHub SSH.

---

## ☁️ Pipeline AWS DevOps

```
CodeCommit (git/github) → CodeBuild (build+test) → Artefact S3
                                                         ↓
                                              CodeDeploy → EC2/ECS/Lambda
                                                         ↓
                                              CodePipeline (orchestration)
```

---

## 🔐 IAM — Identity and Access Management

```
IAM User   → Utilisateur humain avec credentials
IAM Role   → Permissions attribuées à un service AWS
IAM Policy → Document JSON définissant les permissions
MFA        → Multi-Factor Authentication
```

### Bonnes pratiques
```
✅ Ne JAMAIS utiliser le compte root pour le dev
✅ Principe du moindre privilège
✅ Activer MFA sur tous les comptes
✅ Utiliser des rôles IAM pour les instances EC2
```

---

## 🖥️ EC2 — Lancer une Instance

```
1. EC2 → Launch Instance
2. AMI : Ubuntu 24.04 LTS
3. Instance type : t3.micro (Free Tier)
4. Key pair : créer clé .pem
5. Security Group : port 22 (SSH), port 80 (HTTP)
6. Launch !
```

```bash
# Connexion SSH
chmod 400 devops-key.pem
ssh -i "devops-key.pem" ubuntu@<IP_PUBLIQUE>
```

---

## 🔑 Git + GitHub SSH sur EC2

```bash
# Configuration Git
git config --global user.name "Leonel PENGOU"
git config --global user.email "leonelpengou10@gmail.com"

# Générer clé SSH
ssh-keygen -t rsa -b 4096 -C "leonelpengou10@gmail.com"
cat ~/.ssh/id_rsa.pub
# → GitHub : Settings → SSH Keys → New SSH Key → Coller

# Tester
ssh -T git@github.com
# Hi leopen10! You've successfully authenticated

# Cloner
git clone git@github.com:leopen10/100-jours-devops.git

# Configurer remote SSH
git remote set-url origin git@github.com:leopen10/100-jours-devops.git
git remote -v
```

---

## 📊 Les 16 Services AWS Essentiels DevOps

| # | Service | Rôle |
|---|---------|------|
| 1 | EC2 | Serveur virtuel cloud |
| 2 | VPC | Réseau privé virtuel |
| 3 | EBS | Stockage bloc (volume) |
| 4 | S3 | Stockage objets + CDN CloudFront |
| 5 | IAM | Gestion des accès + MFA |
| 6 | CloudWatch | Monitoring via SNS/Lambda |
| 7 | CloudTrail | Gouvernance et audit |
| 8 | Lambda | Serverless computing |
| 9 | CodeBuild/Deploy/Pipeline | CI/CD AWS |
| 10 | AWS Config | Audit de configuration |
| 11 | Billing | Gestion des coûts |
| 12 | KMS | Gestion des clés de chiffrement |
| 13 | EKS | Kubernetes managé AWS |
| 14 | ECS | Containers managés |
| 15 | Fargate | ECS mode serverless |
| 16 | ELK | Elasticsearch, Logstash, Kibana |

---

## ✅ Preuve d'exécution sur AWS EC2

**Instance :** t3.micro — Ubuntu 24.04 — us-east-1  
**IP Publique :** 44.222.105.23 | **Date :** 1 avril 2026

```
✅ EC2 connecté via SSH : ubuntu@ip-172-31-78-7
✅ SSH GitHub : Hi leopen10! You've successfully authenticated
✅ Remote SSH : git@github.com:leopen10/100-jours-devops.git
✅ git push origin main → succès
✅ Nginx : HTTP 200 → http://44.222.105.23
✅ Docker 28.2.2 installé
✅ Python venv : Flask 3.1.3 + pytest 9.0.2

Architecture :
Internet → EC2 t3.micro (us-east-1)
  ├── Ubuntu 24.04 LTS
  ├── Nginx → Site live (port 80)
  ├── Git + SSH GitHub configuré
  ├── Docker 28.2.2
  └── Python + Flask + pytest
```

---

## ➡️ Prochain Jour

[Jour 10 — Introduction Complète à AWS CodeBuild](../jour-10-aws-codebuild/)
