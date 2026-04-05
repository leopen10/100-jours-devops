# Jour 38 — DNS et AWS Route 53 🌐

> ⏱️ Durée : 45 min | 📅 Date : 5 avril 2026 | ✅ Statut : Complété

---

## 🎯 C'est quoi le DNS ?

```
DNS = Domain Name System
→ Annuaire téléphonique d'Internet

Sans DNS :  http://44.222.105.23       (difficile à retenir)
Avec DNS :  http://leonel-devops.com   (facile à retenir)

Résolution DNS :
  leonel-devops.com → DNS Query → 44.222.105.23
```

---

## 📋 Types d'enregistrements DNS

| Type | Usage | Exemple |
|------|-------|---------|
| **A** | Domaine → IPv4 | `leonel.com → 44.222.105.23` |
| **AAAA** | Domaine → IPv6 | `leonel.com → 2001:db8::1` |
| **CNAME** | Alias vers un autre domaine | `www.leonel.com → leonel.com` |
| **MX** | Serveur email | `leonel.com → mail.google.com` |
| **TXT** | Vérification, SPF, DKIM | `v=spf1 include:gmail.com ~all` |
| **NS** | Serveurs de noms | `leonel.com → ns1.awsdns.com` |
| **SOA** | Infos de la zone DNS | Début de chaque zone DNS |

---

## 🔧 Outils pour tester le DNS

```bash
# dig - Interroger le DNS
dig leonel.com A              # Enregistrement A
dig leonel.com MX             # Enregistrement MX
dig @8.8.8.8 leonel.com A    # Via Google DNS

# nslookup - Résolution DNS
nslookup leonel.com
nslookup 44.222.105.23        # Reverse DNS

# Tester depuis l'EC2
dig +short leonel.com
curl -I http://leonel.com
```

---

## 🚀 AWS Route 53

**Route 53** = Service DNS managé d'AWS

```
Fonctionnalités :
✅ Enregistrement de domaines
✅ Hébergement de zones DNS
✅ Routage intelligent du trafic
✅ Health checks automatiques
✅ Intégration native avec EC2, S3, CloudFront, ALB
```

---

## 🔄 Types de Routage Route 53

### 1. Simple Routing
```
leonel.com → 44.222.105.23
→ Un seul enregistrement, pas de health check
→ Usage : Sites simples
```

### 2. Weighted Routing (A/B Testing)
```
leonel.com → 44.222.105.23  (Weight: 80%)
leonel.com → 52.123.456.789 (Weight: 20%)
→ 80% trafic vers serveur 1, 20% vers serveur 2
→ Usage : Déploiement progressif
```

### 3. Latency Routing
```
Utilisateur Europe → Serveur eu-west-1
Utilisateur Asie   → Serveur ap-southeast-1
→ Route vers le serveur le plus proche
→ Usage : Applications globales
```

### 4. Geolocation Routing
```
France   → Serveur eu-west-3 (Paris)
USA      → Serveur us-east-1
Autres   → Serveur par défaut
→ Usage : Contenu localisé, conformité RGPD
```

### 5. Failover Routing
```
Primary  : 44.222.105.23 (actif)
Secondary: 52.123.456.789 (si primary tombe)
→ Basculement automatique si health check échoue
→ Usage : Haute disponibilité
```

---

## 🏗️ Cas Pratique — Django avec Domaine + SSL

### Architecture cible
```
Internet
    ↓
Route 53 (leonel-devops.com)
    ↓
CloudFront (CDN + SSL/HTTPS)
    ↓
EC2 (Django + Gunicorn + Nginx)
    IP : 44.222.105.23
```

### Étape 1 — Créer une zone hébergée Route 53
```bash
aws route53 create-hosted-zone \
    --name leonel-devops.com \
    --caller-reference $(date +%s)
```

### Étape 2 — Créer un enregistrement A
```bash
aws route53 change-resource-record-sets \
    --hosted-zone-id Z1234567890ABC \
    --change-batch '{
        "Changes": [{
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "leonel-devops.com",
                "Type": "A",
                "TTL": 300,
                "ResourceRecords": [
                    {"Value": "44.222.105.23"}
                ]
            }
        }]
    }'
```

### Étape 3 — SSL avec AWS Certificate Manager (ACM)
```bash
# Demander un certificat SSL gratuit
aws acm request-certificate \
    --domain-name leonel-devops.com \
    --validation-method DNS \
    --region us-east-1
```

---

## 🔗 Route 53 + notre formation

```
Notre bucket S3 : devops-artefacts-leonel-2026
Notre domaine   : leonel.com (bucket S3 existant !)

Jour 13 → Site statique sur S3
Jour 38 → Lier leonel.com au bucket via Route 53

Résultat : http://leonel.com → notre site statique S3 !
```

---

## 💰 Tarification Route 53

```
Zone hébergée   : 0.50$/mois/zone
Requêtes DNS    : 0.40$/million
Health checks   : 0.50$/mois/check
Enregistrement  : ~12$/an pour .com

Notre cas :
  1 zone hébergée = 0.50$/mois = 6$/an
  → Très abordable pour un vrai domaine !
```

---

## ✅ Commandes DNS utiles sur notre EC2

```bash
# Tester la résolution DNS
dig +short google.com
nslookup amazon.com

# Vérifier notre IP publique
curl ifconfig.me
curl ipinfo.io/ip

# Tester notre site
curl -I http://44.222.105.23
dig +short 44.222.105.23
```

---

## ➡️ Prochain Jour

[Jour 39 — Projet Complet AWS en Production : VPC, NAT Gateway, ALB & Auto Scaling](../jour-39-projet-aws-production/)
