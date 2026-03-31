# Jour 07 — Shell Scripting Bash 🐚

> ⏱️ Durée : ~45 min | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi le Shell Scripting en DevOps ?

Le shell scripting est le **couteau suisse du DevOps** :
- Automatiser des tâches répétitives (backups, déploiements, monitoring)
- Créer des pipelines CI/CD
- Administrer des serveurs Linux
- Traiter des logs et données système

```
Manuel → Automatisé avec Shell Script
```

---

## 📝 1. Les Bases

### Le Shebang — Première ligne obligatoire
```bash
#!/bin/bash    # Bash (le plus courant en DevOps)
#!/bin/sh      # Shell POSIX générique
#!/bin/dash    # Shell léger
```

### Créer et exécuter un script
```bash
touch mon-script.sh          # Créer le fichier
chmod +x mon-script.sh       # Le rendre exécutable
./mon-script.sh              # L'exécuter
bash mon-script.sh           # Exécuter sans chmod
```

### Options de débogage essentielles
```bash
set -x          # Mode debug : affiche chaque commande avant exécution
set -e          # Arrêter si une commande échoue
set -o pipefail # Arrêter si une commande dans un pipe échoue
set -exo pipefail  # Combinaison recommandée en DevOps
```

---

## 📦 2. Variables et Arguments

```bash
# Variables
NOM="Leonel"
AGE=25
echo "Bonjour $NOM, tu as $AGE ans"

# Variables spéciales
echo $0   # Nom du script
echo $1   # Premier argument
echo $2   # Deuxième argument
echo $@   # Tous les arguments
echo $#   # Nombre d'arguments
echo $?   # Code de retour de la dernière commande
echo $$   # PID du script

# Exemple d'utilisation
./deploy.sh production v1.0
# $1 = production, $2 = v1.0
```

---

## 🔄 3. Stdin, Stdout, Stderr

```bash
# Les 3 flux standards
# stdin  (0) → entrée
# stdout (1) → sortie normale
# stderr (2) → erreurs

# Redirection
commande > fichier.txt       # stdout vers fichier
commande >> fichier.txt      # Ajouter au fichier
commande 2> erreurs.txt      # stderr vers fichier
commande 2>&1                # stderr vers stdout
commande &> tout.txt         # stdout + stderr vers fichier

# Pipe — envoyer la sortie d'une commande vers une autre
ps -ef | grep nginx
ps -ef | grep amazon | awk -F" " '{print $2}'
cat logs.txt | grep "ERROR" | wc -l
```

---

## 🔀 4. Conditions (If/Else)

```bash
#!/bin/bash
set -exo pipefail

A=4
B=10

# Comparaison numérique
if [ $A -gt $B ]; then
    echo "A est plus grand que B"
elif [ $A -eq $B ]; then
    echo "A est égal à B"
else
    echo "B est plus grand que A"
fi

# Opérateurs de comparaison
# -eq  : égal
# -ne  : différent
# -gt  : plus grand
# -lt  : plus petit
# -ge  : plus grand ou égal
# -le  : plus petit ou égal

# Comparaison de chaînes
if [ "$NOM" = "Leonel" ]; then
    echo "Bonjour Leonel !"
fi

# Vérifier si un fichier existe
if [ -f "/etc/nginx/nginx.conf" ]; then
    echo "Nginx est configuré"
fi

# Vérifier si un dossier existe
if [ -d "/var/www/html" ]; then
    echo "Dossier web existe"
fi
```

---

## 🔁 5. Boucles

```bash
# Boucle for — itérer sur une liste
for i in 1 2 3 4 5; do
    echo "Iteration $i"
done

# Boucle for — plage de nombres
for i in {1..10}; do
    echo "Numero : $i"
done

# Boucle for — sur des éléments
SERVEURS=("web1" "web2" "db1")
for serveur in "${SERVEURS[@]}"; do
    echo "Vérification de $serveur..."
    ping -c 1 $serveur > /dev/null && echo "$serveur OK" || echo "$serveur KO"
done

# Boucle while
COMPTEUR=0
while [ $COMPTEUR -lt 5 ]; do
    echo "Compteur : $COMPTEUR"
    COMPTEUR=$((COMPTEUR + 1))
done
```

---

## 🪤 6. Trap — Gestion des Signaux

```bash
# Intercepter un signal pour nettoyer proprement
trap "echo 'Script interrompu !'; exit 1" SIGINT SIGTERM

# Nettoyer les fichiers temporaires à la fin
trap "rm -f /tmp/mon-script-*" EXIT

# Signaux courants
# SIGINT  (2)  → Ctrl+C
# SIGTERM (15) → kill normal
# SIGKILL (9)  → kill -9 (ne peut pas être intercepté)
# EXIT         → À la fin du script (succès ou erreur)
```

---

## 🔍 7. Commandes Utiles en Scripting

```bash
# Rechercher dans des logs
curl -s http://api.example.com | grep "ERROR"
find /var/log -name "*.log" -newer /tmp/last-check

# Traitement de texte
cat /etc/passwd | awk -F":" '{print $1}'   # 1er champ séparé par :
ps -ef | grep nginx | awk '{print $2}'     # PIDs de nginx
grep -r "ERROR" /var/log/ | wc -l          # Compter les erreurs

# Informations système
df -h          # Espace disque
nproc          # Nombre de CPUs
free -h        # Mémoire disponible
top -bn1       # Snapshot des processus

# curl et wget
curl -X GET https://api.github.com/users/leopen10   # API REST
wget https://example.com/fichier.zip                 # Télécharger
```

---

## 🏋️ Projet Pratique
---

## ✅ Preuve d'exécution sur AWS EC2

**Serveur :** Ubuntu 24.04 — AWS EC2 t3.micro — us-east-1  
**Date :** 31 mars 2026
```
==========================================
 JOUR 07 - Script DevOps Complet
 Tue Mar 31 22:34:28 UTC 2026
==========================================

✅ nginx  : actif
✅ ssh    : actif
💾 Disque : 31% utilisé - OK
🧠 Mémoire: 41% utilisée - OK
🖥️  CPUs  : 2 cores
⏱️  Uptime : up 2 hours, 7 minutes
🌐 Site web: HTTP 200 - OK

>>> Déploiement d'une mise à jour...
✅ update.html déployé
✅ Nginx rechargé
📋 Erreurs Nginx: 0

LOG HORODATÉ :
[2026-03-31 22:34:28] SERVICE OK: nginx
[2026-03-31 22:34:28] SERVICE OK: ssh
[2026-03-31 22:34:28] DISK OK: 31%
[2026-03-31 22:34:28] MEMORY OK: 41%
[2026-03-31 22:34:28] WEB OK: HTTP 200
[2026-03-31 22:34:28] Déploiement terminé ✓
✅ Script Jour 07 terminé avec succès !
```

**Concepts démontrés :**
- `set -exo pipefail` — mode debug + gestion d'erreurs
- Fonctions Bash avec variables locales
- Boucles `for` sur tableaux
- Conditions `if/else` avec seuils
- `trap` — nettoyage automatique à la fin
- `curl`, `systemctl`, `df`, `free`, `nproc`
- Logs horodatés avec `tee`
- Déploiement automatisé Nginx
```

**Message de commit :**
```
docs: add execution proof on AWS EC2 - jour 07

Voir [`projet-devops.sh`](./projet-devops.sh) — Script de monitoring et déploiement automatisé complet avec toutes les notions du cours.

---

## ➡️ Prochain Jour

[Jour 08 — GitHub Course (Fork, Clone, PR)](../jour-08-github/)
