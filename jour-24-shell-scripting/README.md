# Jour 24 — Cours Complet Shell Scripting Linux pour DevOps 🖥️

> ⏱️ Durée : 1h30 | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi le Shell Scripting ?

```
Sans Shell Script          Avec Shell Script
─────────────────          ─────────────────
100 commandes manuelles → 1 script automatisé
30 minutes de travail   → 30 secondes
Source d'erreurs        → Reproductible
Non documenté           → Lisible et versionné
```

---

## 1️⃣ Fondamentaux du Shell

### Premier script
```bash
#!/bin/bash
# Mon premier script DevOps
echo "Hello DevOps !"
echo "Date : $(date)"
echo "Serveur : $(hostname)"
```

### Exécuter un script
```bash
chmod +x mon_script.sh    # Rendre exécutable
./mon_script.sh           # Lancer le script
bash mon_script.sh        # Alternative
```

### Variables
```bash
#!/bin/bash
NOM="Leonel"
AGE=25
SERVEUR=$(hostname)        # Capture la sortie d'une commande

echo "Nom : $NOM"
echo "Age : $AGE"
echo "Serveur : $SERVEUR"
```

---

## 2️⃣ Commandes Linux Essentielles DevOps

### Gestion des fichiers
```bash
ls -la                     # Lister avec détails
mkdir -p dossier/sous      # Créer dossiers imbriqués
touch fichier.txt          # Créer un fichier vide
find /var/log -name "*.log" -mtime +7  # Trouver fichiers > 7 jours
cp -r source/ destination/ # Copier récursivement
rm -rf dossier/            # Supprimer récursivement
```

### Gestion des processus
```bash
ps aux                     # Lister tous les processus
ps aux | grep nginx        # Filtrer un processus
kill -9 PID                # Forcer l'arrêt d'un processus
killall nginx              # Arrêter par nom
trap "echo 'Interrupted'" SIGINT  # Intercepter Ctrl+C
```

### Surveillance système
```bash
top                        # Monitorer en temps réel
htop                       # Version améliorée de top
df -h                      # Espace disque
free -h                    # Mémoire RAM
uptime                     # Charge système
netstat -tulpn             # Ports ouverts
```

### Téléchargement et communication
```bash
curl -I http://mon-site.com        # Headers HTTP
curl -o fichier.zip https://url    # Télécharger
wget https://url/fichier.tar.gz    # Télécharger
curl -X POST -H "Content-Type: application/json" \
     -d '{"key":"value"}' https://api.example.com
```

---

## 3️⃣ Structures de Contrôle

### Conditions (if/else)
```bash
#!/bin/bash

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ $DISK_USAGE -gt 80 ]; then
    echo "ALERTE : Disque plein a $DISK_USAGE%"
    # Envoyer une alerte
elif [ $DISK_USAGE -gt 60 ]; then
    echo "ATTENTION : Disque a $DISK_USAGE%"
else
    echo "OK : Disque a $DISK_USAGE%"
fi
```

### Boucles (for)
```bash
#!/bin/bash

# Boucle sur une liste
for SERVEUR in web1 web2 web3; do
    echo "Vérification de $SERVEUR..."
    ping -c 1 $SERVEUR &>/dev/null && echo "$SERVEUR : OK" || echo "$SERVEUR : KO"
done

# Boucle sur des fichiers
for FICHIER in /var/log/*.log; do
    echo "Traitement : $FICHIER"
    wc -l $FICHIER
done
```

### Boucles (while)
```bash
#!/bin/bash

COMPTEUR=0
while [ $COMPTEUR -lt 5 ]; do
    echo "Tentative $COMPTEUR..."
    COMPTEUR=$((COMPTEUR + 1))
    sleep 1
done
```

### Fonctions
```bash
#!/bin/bash

# Définir une fonction
verifier_service() {
    local SERVICE=$1
    if systemctl is-active --quiet $SERVICE; then
        echo "✅ $SERVICE est actif"
    else
        echo "❌ $SERVICE est inactif"
        systemctl start $SERVICE
    fi
}

# Appeler la fonction
verifier_service nginx
verifier_service gunicorn
verifier_service mysql
```

---

## 4️⃣ Manipulation des Fichiers et Texte

### grep, awk, sed
```bash
# grep - Rechercher dans un fichier
grep "ERROR" /var/log/nginx/error.log
grep -c "200" /var/log/nginx/access.log  # Compter les occurrences

# awk - Traiter des colonnes
ps aux | awk '{print $1, $2, $11}'   # User, PID, Commande
df -h | awk 'NR>1 {print $5, $6}'   # Usage disque

# sed - Modifier du texte
sed -i 's/HOOYIA/LEONEL/g' fichier.txt   # Remplacer
sed -n '1,10p' fichier.txt               # Afficher lignes 1-10
```

### Redirection et pipes
```bash
# Redirection
commande > fichier.txt     # Écraser
commande >> fichier.txt    # Ajouter
commande 2> erreurs.txt    # Erreurs uniquement
commande &> tout.txt       # Tout capturer

# Pipes
ps aux | grep nginx | awk '{print $2}'  # PID de nginx
cat /etc/passwd | cut -d: -f1 | sort   # Liste des utilisateurs
```

---

## 5️⃣ Scripts DevOps Pratiques

### Script de monitoring système
```bash
#!/bin/bash
# ============================================
# monitoring.sh - Surveillance système DevOps
# Auteur : Leonel-Magloire PENGOU MBA
# ============================================

LOG_FILE="/var/log/monitoring.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

log() {
    echo "[$DATE] $1" | tee -a $LOG_FILE
}

# CPU
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | tr -d '%us,')
log "CPU : $CPU%"

# RAM
RAM=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
log "RAM : $RAM%"

# Disque
DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
log "Disque : $DISK%"

# Services
for SERVICE in nginx gunicorn; do
    systemctl is-active --quiet $SERVICE \
        && log "Service $SERVICE : OK" \
        || log "ALERTE : Service $SERVICE INACTIF"
done

log "--- Fin du monitoring ---"
```

### Script de déploiement
```bash
#!/bin/bash
# deploy.sh - Script de déploiement automatique
set -e  # Arrêter si une commande échoue

APP_DIR="/home/ubuntu/django-invoice"
VENV="/home/ubuntu/venv-devops"

echo "=== Debut du deploiement $(date) ==="

# Pull du code
cd $APP_DIR
git pull origin main
echo "✅ Code mis a jour"

# Installer les dépendances
source $VENV/bin/activate
pip install -r requirements.txt -q
echo "✅ Dependances installees"

# Migrations
python manage.py migrate --noinput
echo "✅ Migrations effectuees"

# Fichiers statiques
python manage.py collectstatic --noinput
echo "✅ Statiques collectes"

# Restart services
sudo systemctl restart gunicorn
sudo systemctl restart nginx
echo "✅ Services redemarres"

echo "=== Deploiement termine $(date) ==="
```

---

## ✅ Preuve — Scripts Pratiqués

```bash
# Scripts qu'on a déjà créés dans la formation :
✅ scripts/stop_app.sh      → Jour 22 (CodeDeploy hooks)
✅ scripts/install_deps.sh  → Jour 22
✅ scripts/validate.sh      → Jour 22
✅ deploy.sh                → Jour 09 (premier déploiement)
✅ monitoring.sh            → Jour 14-15 (CloudWatch)

# Pipeline GitHub Actions = Shell Script orchestré :
✅ git pull origin main
✅ pip install -r requirements.txt
✅ python manage.py migrate
✅ sudo systemctl restart gunicorn nginx
```

---

## ➡️ Prochain Jour

[Jour 25 — Questions d'Entretien Shell Scripting pour DevOps](../jour-25-questions-shell-scripting/)
