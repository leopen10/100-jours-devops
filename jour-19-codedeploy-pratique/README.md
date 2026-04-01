# Jour 19 — AWS CodeDeploy : Configuration et Déploiement Pratique ⚙️

> ⏱️ Durée : 42 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Configurer AWS CodeDeploy de A à Z et déployer une application sur EC2 :
1. Créer les rôles IAM nécessaires
2. Configurer le Instance Profile EC2
3. Installer l'agent CodeDeploy
4. Créer l'application et le Deployment Group
5. Premier déploiement réel

---

## 🔐 ÉTAPE 1 — Rôle IAM CodeDeploy Service Role

```
Console AWS → IAM → Rôles → Créer un rôle

Configuration :
  ├── Type d'entité   : AWS Service
  ├── Cas d'utilisation : CodeDeploy
  ├── Policy auto     : AWSCodeDeployRole ✅
  └── Nom du rôle    : CodeDeployServiceRole ✅
```

**Policy attachée automatiquement :**
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:*",
    "autoscaling:*",
    "elasticloadbalancing:*",
    "s3:GetObject",
    "s3:GetObjectVersion",
    "s3:ListBucket"
  ]
}
```

---

## 🖥️ ÉTAPE 2 — Instance Profile IAM pour EC2

```
Console AWS → IAM → Rôles → Créer un rôle

Configuration :
  ├── Type d'entité   : AWS Service
  ├── Cas d'utilisation : EC2
  ├── Policy          : AmazonS3ReadOnlyAccess ✅
  └── Nom du rôle    : EC2InstanceProfileCodeDeploy ✅
```

---

## 🔗 ÉTAPE 3 — Attacher le Profil à l'Instance EC2

```
Console AWS → EC2 → Instances → devops-jour3

Actions → Sécurité → Modifier le rôle IAM
  └── Rôle IAM : EC2InstanceProfileCodeDeploy ✅
```

---

## ⚙️ ÉTAPE 4 — Installer l'Agent CodeDeploy sur EC2

```bash
# Installation Ruby (requis par l'agent)
sudo apt update -y
sudo apt install ruby wget -y

# Télécharger l'installateur
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x install

# Installer l'agent
sudo ./install auto

# Démarrer et activer
sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent
sudo systemctl status codedeploy-agent
```

---

## ✅ Preuve d'exécution — Agent CodeDeploy Actif

**Serveur :** Ubuntu 24.04 — AWS EC2 t3.micro — us-east-1  
**Date :** 1 avril 2026

```
● codedeploy-agent.service - LSB: AWS CodeDeploy Host Agent
   Loaded : loaded (/etc/init.d/codedeploy-agent; generated)
   Active : active (running) ✅
   Version: 1.8.1-26
   Memory : 68 MB
   CPU    : 1.071s

Processus :
  ├── 8170 "codedeploy-agent: master 8170"
  └── 8173 "codedeploy-agent: InstanceAgent::Plugins::CodeDeployPlugin::CommandPoller"

Apr 01 05:18:41 Started codedeploy-agent.service ✅
```

---

## 🏗️ ÉTAPE 5 — Créer l'Application CodeDeploy

```
Console AWS → CodeDeploy → Applications → Créer une application

Configuration :
  ├── Nom        : devops-leonel-app
  └── Plateforme : EC2/On-premises
```

⚠️ **Note :** Le compte AWS Free Tier non activé complètement ne permet pas
l'accès à CodeDeploy (`SubscriptionRequiredException`).
L'agent est installé et prêt — le déploiement sera fait dès l'activation du compte.

---

## 📄 Structure du Projet pour CodeDeploy

```
mon-app/
├── appspec.yml          ← Config CodeDeploy
├── app.py               ← Application Flask
├── requirements.txt     ← Dépendances
└── scripts/
    ├── stop.sh          ← Arrêter l'app
    ├── install.sh       ← Installer les deps
    ├── start.sh         ← Démarrer l'app
    └── validate.sh      ← Valider le service
```

### appspec.yml
```yaml
version: 0.0
os: linux

files:
  - source: /
    destination: /home/ubuntu/app/

hooks:
  ApplicationStop:
    - location: scripts/stop.sh
      timeout: 300
      runas: ubuntu
  BeforeInstall:
    - location: scripts/install.sh
      timeout: 300
      runas: ubuntu
  ApplicationStart:
    - location: scripts/start.sh
      timeout: 300
      runas: ubuntu
  ValidateService:
    - location: scripts/validate.sh
      timeout: 300
      runas: ubuntu
```

### scripts/stop.sh
```bash
#!/bin/bash
sudo systemctl stop myapp 2>/dev/null || true
echo "Application arretee"
```

### scripts/install.sh
```bash
#!/bin/bash
cd /home/ubuntu/app
pip install -r requirements.txt
echo "Dependances installees"
```

### scripts/start.sh
```bash
#!/bin/bash
cd /home/ubuntu/app
source venv/bin/activate
nohup python app.py > /tmp/app.log 2>&1 &
echo "Application demarree"
```

### scripts/validate.sh
```bash
#!/bin/bash
sleep 5
curl -f http://localhost:5000/health || exit 1
echo "Service valide OK"
```

---

## 📊 Bilan des Rôles et Permissions

| Rôle | Service | Permissions | Statut |
|------|---------|-------------|--------|
| `CodeDeployServiceRole` | CodeDeploy | AWSCodeDeployRole | ✅ Créé |
| `EC2InstanceProfileCodeDeploy` | EC2 | AmazonS3ReadOnlyAccess | ✅ Créé |

---

## 🔄 Ce qu'on utilise à la place — GitHub Actions → EC2

Notre pipeline actuel (équivalent CodeDeploy) :
```
GitHub Push
    ↓
GitHub Actions
    ├── Checkout code
    ├── Configure AWS credentials
    ├── Deploy vers S3 (Jour 13) ✅
    └── (prochain : SSH deploy vers EC2)
```

---

## ➡️ Prochain Jour

[Jour 20 — AWS CodePipeline : Introduction et Concepts](../jour-20-aws-codepipeline/)
