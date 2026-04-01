# Jour 16 — Introduction à AWS CodeDeploy 🚀

> ⏱️ Durée : 8 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Rappel Pipeline DevOps

```
Développement → Build → Test → Déploiement → Monitoring
     VSCode       CodeBuild  CodeBuild  CodeDeploy  CloudWatch
```

**CodeDeploy** est le service qui automatise l'étape **Déploiement**.

---

## 🤔 Pourquoi AWS CodeDeploy ?

### Comparaison des méthodes de déploiement

| Méthode | Avantages | Inconvénients |
|---------|-----------|---------------|
| **Manuel** | Simple à comprendre | Lent, source d'erreurs, pas scalable |
| **Scripts Bash** | Automatisé | Complexe à maintenir, pas de rollback |
| **AWS CodeDeploy** | Automatisé + scalable + rollback | Apprentissage initial |

### Problèmes du déploiement manuel
```
🕒 Time-consuming   → Chaque étape à la main
❌ Error-prone      → Erreurs humaines fréquentes
🌀 Pas de rollback  → Difficile à annuler
📈 Non scalable     → Impossible sur 100 serveurs
```

---

## 🏗️ AWS CodeDeploy — Architecture

### Destinations de déploiement
```
CodeDeploy
  ├── EC2 (serveurs virtuels)
  ├── Lambda (serverless)
  ├── ECS (containers)
  └── On-premises (serveurs physiques)
```

### Pipeline complet
```
Code (GitHub/CodeCommit)
         ↓
   CodeBuild (build + test)
         ↓
   Artefact S3
         ↓
   CodeDeploy → Deployment Group (plusieurs serveurs)
         ↓
   CloudWatch (monitoring)
         ↓
   CloudTrail (audit)
```

---

## 👥 Deployment Group — Concept clé

Un **Deployment Group** est un ensemble de serveurs EC2 ciblés par un déploiement.

```
Application : mon-app-devops
  └── Deployment Group : production
        ├── EC2 instance 1 (tag: env=prod)
        ├── EC2 instance 2 (tag: env=prod)
        └── EC2 instance 3 (tag: env=prod)
```

### Création d'un Deployment Group
```
Console AWS → CodeDeploy → Applications → Create Application
  ├── Application name : devops-leonel-app
  ├── Compute platform : EC2/On-premises
  └── Deployment Group :
        ├── Nom : production-group
        ├── IAM Role : CodeDeployServiceRole
        ├── Deployment type : In-place / Blue/Green
        └── EC2 instances : Tag key=env, value=prod
```

---

## 🔄 Stratégies de Déploiement

### 1. In-Place (Rolling)
```
Serveur 1 → Stop → Deploy → Start
Serveur 2 → Stop → Deploy → Start
Serveur 3 → Stop → Deploy → Start
→ Risque : downtime possible
```

### 2. Blue/Green
```
Ancien (Blue) : 3 serveurs en prod
Nouveau (Green) : 3 nouveaux serveurs déployés
→ Switch du load balancer : Blue → Green
→ Avantage : zéro downtime + rollback instantané
```

### 3. Canary
```
5% du trafic → Nouvelle version
95% du trafic → Ancienne version
→ Surveillance 10 min
→ Si OK : 100% sur nouvelle version
```

---

## 📄 appspec.yml — Fichier de configuration

```yaml
version: 0.0
os: linux

files:
  - source: /
    destination: /home/ubuntu/app/

hooks:
  BeforeInstall:
    - location: scripts/stop_app.sh
      timeout: 300

  AfterInstall:
    - location: scripts/install_deps.sh
      timeout: 300

  ApplicationStart:
    - location: scripts/start_app.sh
      timeout: 300

  ValidateService:
    - location: scripts/validate.sh
      timeout: 300
```

### Hooks disponibles
```
ApplicationStop    → Arrêter l'ancienne version
DownloadBundle     → Télécharger l'artefact S3
BeforeInstall      → Avant l'installation
Install            → Copier les fichiers
AfterInstall       → Après l'installation
ApplicationStart   → Démarrer la nouvelle version
ValidateService    → Valider que ça marche
```

---

## 🔐 IAM Role pour CodeDeploy

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": "codedeploy.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
```

Policy à attacher : `AWSCodeDeployRole`

---

## ✅ Ce qu'on a déjà fait (équivalent CodeDeploy)

```
Jour 09 → deploy.sh vers EC2 via SSH ✅
Jour 13 → GitHub Actions → aws s3 cp → S3 ✅

Scripts équivalents aux hooks CodeDeploy :
  BeforeInstall  : sudo systemctl stop nginx
  AfterInstall   : pip install -r requirements.txt
  ApplicationStart : sudo systemctl start nginx
  ValidateService : curl http://localhost/health
```

---

## ➡️ Prochain Jour

[Jour 17 — Pourquoi Choisir AWS CodeDeploy](../jour-17-pourquoi-codedeploy/)
