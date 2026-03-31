# Jour 03 — Déployer une Application Statique avec Linux 🌐

> ⏱️ Durée : 25 minutes | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🎯 Objectif du Projet

Déployer une application web statique sur un serveur Ubuntu avec **Nginx** en utilisant les commandes Linux apprises aux Jours 2 et 3.

---

## 🏗️ Architecture

```
Internet
    │
    ▼
[Serveur Ubuntu]
    │
    ├── Nginx (port 80)
    │       │
    │       └── /var/www/html/devops-portfolio/
    │                   └── index.html
    │
    └── Logs → /var/log/nginx/
```

---

## 📋 Étapes de Déploiement

### 1. Mise à jour du système
```bash
sudo apt update -y
```

### 2. Installation de Nginx
```bash
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx   # Démarrage automatique
sudo systemctl status nginx   # Vérifier le statut
```

### 3. Créer la structure du site
```bash
sudo mkdir -p /var/www/html/devops-portfolio
```

### 4. Copier les fichiers
```bash
sudo cp index.html /var/www/html/devops-portfolio/
```

### 5. Configurer les permissions
```bash
sudo chown -R www-data:www-data /var/www/html/devops-portfolio
sudo chmod -R 755 /var/www/html/devops-portfolio
```

### 6. Configurer le Virtual Host Nginx
```bash
sudo nano /etc/nginx/sites-available/devops-portfolio
```

Contenu du fichier :
```nginx
server {
    listen 80;
    server_name _;

    root /var/www/html/devops-portfolio;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/devops-portfolio-access.log;
    error_log /var/log/nginx/devops-portfolio-error.log;
}
```

### 7. Activer le site et recharger Nginx
```bash
sudo ln -sf /etc/nginx/sites-available/devops-portfolio /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default   # Désactiver le site par défaut
sudo nginx -t                                  # Tester la configuration
sudo systemctl reload nginx                    # Recharger Nginx
```

### 8. Tester le déploiement
```bash
curl -I http://localhost/          # Tester en local
# Puis ouvrir : http://[IP-DU-SERVEUR] dans le navigateur
```

---

## 📁 Structure du Projet

```
jour-03-linux-partie2/
├── README.md         ← Ce fichier
├── index.html        ← Page web statique
├── deploy.sh         ← Script de déploiement automatisé
└── nginx.conf        ← Configuration Nginx
```

---

## 🔑 Commandes Clés Apprises

| Commande | Description |
|---------|-------------|
| `sudo apt install nginx` | Installer Nginx |
| `sudo systemctl start/stop/restart nginx` | Gérer le service |
| `sudo systemctl enable nginx` | Activer au démarrage |
| `sudo nginx -t` | Tester la configuration |
| `sudo systemctl reload nginx` | Recharger sans coupure |
| `chown -R www-data:www-data /var/www/` | Donner ownership à Nginx |
| `chmod -R 755 /var/www/html/` | Permissions lecture/exec |
| `curl -I http://localhost` | Tester HTTP en local |

---

## 💡 Points Importants

- **www-data** est l'utilisateur sous lequel Nginx tourne — les fichiers web doivent lui appartenir
- **chmod 755** sur les dossiers = lecture + exécution pour tous
- **sites-available** contient les configs, **sites-enabled** contient les liens symboliques actifs
- `nginx -t` avant tout reload pour éviter les erreurs de syntaxe
- Les logs Nginx sont dans `/var/log/nginx/` — indispensables pour le debugging

---

## ✅ Résultat

Site déployé et accessible via navigateur sur `http://[IP-SERVEUR]` avec :
- Page HTML professionnelle avec profil DevOps
- Configuration Nginx optimisée
- ---

## 🌐 Démo Live

- **URL :** http://44.222.105.23
- **Serveur :** AWS EC2 t3.micro — Ubuntu 24.04 — us-east-1 (Virginie du Nord)
- **Déployé le :** 31 mars 2026

![Site déployé](screenshot.png)

---

## 🏆 Preuve de déploiement

Site accessible publiquement via Nginx sur AWS EC2.
Déploiement réalisé en suivant les étapes du script `deploy.sh`.
- Permissions sécurisées
- Logs configurés

---

## ➡️ Prochain Jour

[Jour 04 — Linux Partie III](../jour-04-linux-partie3/)
