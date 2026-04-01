# Jour 17 — Pourquoi Choisir AWS CodeDeploy pour Vos Déploiements 🚀

> ⏱️ Durée : 19 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## ❌ Problèmes des Méthodes Traditionnelles

### 1. Déploiement Manuel
```
❌ Erreurs fréquentes (humaines)
❌ Manque d'évolutivité (1 serveur OK, 100 serveurs impossible)
❌ Temps perdu (répétitif)
❌ Pas de rollback automatique
❌ Pas de suivi des déploiements
```

### 2. Déploiement par Scripts
```
❌ Maintenance complexe
❌ Gestion limitée des erreurs
❌ Pas de stratégie avancée (Blue/Green, Canary)
❌ Difficile à monitorer
❌ Pas intégré aux outils AWS
```

---

## ✅ Avantages d'AWS CodeDeploy

```
✅ Multi-environnements : dev → test → prod
✅ Intégration native AWS (CodePipeline, CodeBuild, CloudWatch)
✅ Rollback automatique en cas d'échec
✅ Gestion des erreurs automatisée
✅ Stratégies avancées (Blue/Green, Rolling, Canary)
✅ Monitoring intégré (CloudWatch)
✅ Déploiement sur EC2, Lambda, ECS, On-premises
✅ Pay-as-you-go (pas de coût fixe)
```

---

## 🔄 Stratégies de Déploiement

### 1. Blue/Green Deployment ⭐
```
AVANT:
  Load Balancer → Blue (v1.0) [3 serveurs en prod]

PENDANT:
  Load Balancer → Blue (v1.0) [toujours actif]
                → Green (v2.0) [nouveau déploiement]

APRÈS:
  Load Balancer → Green (v2.0) [switch instantané]
  Blue (v1.0) → En attente (rollback possible)

Avantages :
  ✅ Zéro downtime
  ✅ Rollback instantané (remettre Blue)
  ✅ Tests sur Green avant switch
```

### 2. Rolling Deployment (In-Place)
```
Serveur 1 → Stop v1.0 → Deploy v2.0 → Start v2.0 ✅
Serveur 2 → Stop v1.0 → Deploy v2.0 → Start v2.0 ✅
Serveur 3 → Stop v1.0 → Deploy v2.0 → Start v2.0 ✅

Avantages :
  ✅ Économique (pas de nouveaux serveurs)
  ❌ Downtime possible
  ❌ Rollback plus complexe
```

### 3. Canary Deployment
```
Étape 1 :  5% trafic → v2.0  |  95% trafic → v1.0
           Surveillance 10 min
           
Étape 2 :  Si OK → 100% trafic → v2.0
           Si KO → 100% trafic → v1.0 (rollback auto)

Avantages :
  ✅ Test progressif en production
  ✅ Risque minimal
  ✅ Rollback automatique si erreurs
```

### 4. All-at-once
```
Tous les serveurs → Deploy v2.0 simultanément
Avantage : Rapide
Inconvénient : Downtime total si erreur
```

---

## 🔗 Intégration AWS Complète

```
GitHub / CodeCommit
       ↓
  CodeBuild (build + test)
       ↓
  Artefact S3
       ↓
  CodeDeploy (stratégie de déploiement)
       ↓
  EC2 / Lambda / ECS
       ↓
  CloudWatch (monitoring)
       ↓
  SNS (alertes email)
       ↓
  CloudTrail (audit)
```

---

## 💰 Coût AWS CodeDeploy

```
EC2 / On-premises : GRATUIT
Lambda / ECS      : Payant (à la demande)
```

---

## ✅ Ce qu'on utilise — Équivalent CodeDeploy

```
Notre pipeline (Jour 13) utilise la stratégie All-at-once :

GitHub Push
    ↓
GitHub Actions (équivalent CodeBuild)
    ↓
aws s3 cp → S3 (équivalent artefact)
    ↓
Site mis à jour instantanément

Stratégie Blue/Green → à implémenter avec EC2 + Load Balancer
```

---

## ➡️ Prochain Jour

[Jour 18 — AWS CodeDeploy : Plateformes, Composants et Stratégies](../jour-18-codedeploy-composants/)
