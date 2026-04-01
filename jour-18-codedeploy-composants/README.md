# Jour 18 — AWS CodeDeploy : Plateformes, Composants et Stratégies 🏗️

> ⏱️ Durée : 35 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🖥️ Plateformes Prises en Charge

| Plateforme | Description | Usage |
|------------|-------------|-------|
| **Amazon EC2** | Instances virtuelles | Applications web, APIs |
| **AWS Lambda** | Serverless | Functions event-driven |
| **Amazon ECS** | Containers managés | Microservices Docker |
| **On-premises** | Serveurs physiques | Migration vers cloud |

---

## 🧩 Composants Essentiels

### 1. Application
Groupe logique qui contient tout ce qui concerne ton déploiement.
```
Application : devops-leonel-app
  ├── Deployment Group : production
  ├── Deployment Group : staging
  └── Deployment Group : dev
```

### 2. Plateforme de Calcul
La destination du déploiement (EC2, Lambda, ECS).

### 3. IAM Instance Profile
Permissions que l'instance EC2 a pour accéder aux ressources AWS.
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket"
    ],
    "Resource": "arn:aws:s3:::devops-artefacts-leonel-2026/*"
  }]
}
```

### 4. AppSpec File (appspec.yml)
Fichier YAML définissant le processus de déploiement complet.

```yaml
version: 0.0
os: linux

files:
  - source: /app
    destination: /home/ubuntu/app

hooks:
  ApplicationStop:
    - location: scripts/stop.sh
      timeout: 300
      runas: ubuntu

  BeforeInstall:
    - location: scripts/install_deps.sh
      timeout: 300
      runas: ubuntu

  AfterInstall:
    - location: scripts/configure.sh
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

### 5. Deployment Group
Ensemble d'instances EC2 ciblées par le déploiement.
```
Deployment Group : production
  ├── Tag filter : env = prod
  ├── Load Balancer : mon-alb
  ├── Deployment config : CodeDeployDefault.OneAtATime
  └── Alarms : cpu-high-alarm
```

### 6. CodeDeploy Agent
Agent installé sur chaque instance EC2 pour recevoir les instructions.
```bash
# Installation de l'agent CodeDeploy sur Ubuntu
sudo apt update
sudo apt install ruby wget -y
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo systemctl status codedeploy-agent
```

---

## 🔄 Stratégies de Déploiement Avancées

### EC2 — Deployment Configurations
```
CodeDeployDefault.AllAtOnce      → Tous les serveurs simultanément
CodeDeployDefault.HalfAtATime    → 50% des serveurs à la fois
CodeDeployDefault.OneAtATime     → Un serveur à la fois (rolling)
```

### Lambda — Traffic Shifting
```
CodeDeployDefault.LambdaAllAtOnce   → Bascule 100% instantanément
CodeDeployDefault.LambdaCanary10p5m → 10% pendant 5 min puis 100%
CodeDeployDefault.LambdaLinear10p1m → +10% par minute
```

### ECS — Blue/Green
```
CodeDeployDefault.ECSAllAtOnce      → Bascule immédiate
CodeDeployDefault.ECSCanary10p5m    → 10% pendant 5 min
CodeDeployDefault.ECSLinear10p1m    → +10% par minute
```

---

## 🔁 Cycle de Vie d'un Déploiement

```
1. PENDING        → En attente de démarrage
2. IN_PROGRESS    → Déploiement en cours
3. SUCCEEDED      → Déploiement réussi ✅
4. FAILED         → Échec → Rollback automatique ❌
5. STOPPED        → Arrêté manuellement
6. READY          → Prêt (Blue/Green uniquement)
```

---

## 🛡️ Rollback Automatique

```
Conditions de rollback :
  ├── Build échoué
  ├── Alarme CloudWatch déclenchée
  ├── ValidateService échoué
  └── Timeout dépassé

Rollback = redéploiement de la dernière version stable
```

---

## ✅ Scripts Pratiques

### stop.sh
```bash
#!/bin/bash
sudo systemctl stop myapp 2>/dev/null || true
echo "Application arrêtée"
```

### start.sh
```bash
#!/bin/bash
cd /home/ubuntu/app
source venv/bin/activate
nohup python app.py &
echo "Application démarrée"
```

### validate.sh
```bash
#!/bin/bash
sleep 5
curl -f http://localhost:5000/health || exit 1
echo "Service validé ✅"
```

---

## ➡️ Prochain Jour

[Jour 19 — AWS CodeDeploy : Configuration et Déploiement Pratique](../jour-19-codedeploy-pratique/)
