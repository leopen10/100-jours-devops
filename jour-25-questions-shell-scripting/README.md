# Jour 25 — Questions d'Entretien Shell Scripting pour DevOps 🎯

> ⏱️ Durée : 45 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Préparer les questions d'entretien DevOps sur le Shell Scripting et Linux.

---

## 1️⃣ Commandes Linux Essentielles

**Q. Quelle commande liste les fichiers avec leurs permissions ?**
```bash
ls -la
```

**Q. Comment chercher un fichier contenant un mot précis ?**
```bash
grep -r "mot_recherche" /dossier/
grep -r "ERROR" /var/log/ --include="*.log"
```

**Q. Comment trouver les 10 fichiers les plus volumineux ?**
```bash
find / -type f -exec du -h {} + | sort -rh | head -10
```

**Q. Comment surveiller l'espace disque ?**
```bash
df -h              # Espace disque par partition
du -sh /var/log/   # Taille d'un dossier
```

**Q. Comment lister les processus qui consomment le plus de CPU ?**
```bash
ps aux --sort=-%cpu | head -10
top -b -n1 | head -20
```

**Q. Quelle est la différence entre ps et top ?**
> `ps` = snapshot statique des processus. `top` = monitoring dynamique en temps réel.

**Q. Commande pour voir les ports ouverts ?**
```bash
netstat -tulpn
ss -tulpn          # Alternative moderne
```

---

## 2️⃣ Scripts Shell Pratiques — Questions d'Entretien

**Q. Écrire un script qui liste les processus en cours :**
```bash
#!/bin/bash
echo "=== Processus en cours ==="
ps aux | awk '{print $1, $2, $3, $11}' | head -20
echo "Total : $(ps aux | wc -l) processus"
```

**Q. Filtrer les erreurs d'un fichier de log distant :**
```bash
#!/bin/bash
LOG_URL="http://mon-serveur.com/app.log"
curl -s $LOG_URL | grep "ERROR" | tail -20
```

**Q. Compter les occurrences d'un caractère dans une chaîne :**
```bash
#!/bin/bash
CHAINE="hello world devops"
CARACTERE="o"
COUNT=$(echo "$CHAINE" | tr -cd "$CARACTERE" | wc -c)
echo "Le caractere '$CARACTERE' apparait $COUNT fois"
```

**Q. Afficher les nombres divisibles par 3 ou 5 mais pas 15 :**
```bash
#!/bin/bash
for i in $(seq 1 100); do
    if (( i % 15 == 0 )); then
        continue               # Exclure les multiples de 15
    elif (( i % 3 == 0 )) || (( i % 5 == 0 )); then
        echo $i
    fi
done
```

**Q. Script de vérification de santé d'un service :**
```bash
#!/bin/bash
SERVICE="nginx"
URL="http://localhost"

# Vérifier le service
if systemctl is-active --quiet $SERVICE; then
    echo "✅ $SERVICE est actif"
else
    echo "❌ $SERVICE est inactif - Redémarrage..."
    sudo systemctl restart $SERVICE
fi

# Vérifier la réponse HTTP
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)
if [ "$HTTP_CODE" == "200" ]; then
    echo "✅ HTTP $HTTP_CODE - Site accessible"
else
    echo "❌ HTTP $HTTP_CODE - Site inaccessible"
fi
```

---

## 3️⃣ Concepts et Différences Clés

**Q. Quelle est la différence entre un lien symbolique et un lien physique ?**
```bash
# Lien physique - pointe vers les données du fichier
ln fichier.txt lien_physique.txt

# Lien symbolique - pointe vers le nom du fichier
ln -s fichier.txt lien_symbolique.txt
```
> Lien physique : survit si le fichier original est supprimé.
> Lien symbolique : cassé si le fichier original est supprimé.

**Q. Quelle est la différence entre break et continue ?**
```bash
for i in 1 2 3 4 5; do
    if [ $i -eq 3 ]; then
        break      # Arrête complètement la boucle
    fi
    echo $i
done
# Affiche : 1 2

for i in 1 2 3 4 5; do
    if [ $i -eq 3 ]; then
        continue   # Passe à l'itération suivante
    fi
    echo $i
done
# Affiche : 1 2 4 5
```

**Q. Comment automatiser une tâche avec crontab ?**
```bash
crontab -e    # Editer les tâches cron
crontab -l    # Lister les tâches cron

# Format : minute heure jour mois jour_semaine commande
# Exemples :
0 2 * * *     /home/ubuntu/backup.sh          # Chaque nuit à 2h
*/5 * * * *   /home/ubuntu/monitoring.sh      # Toutes les 5 minutes
0 0 * * 1     /home/ubuntu/rapport.sh         # Chaque lundi minuit
0 9 1 * *     /home/ubuntu/facturation.sh     # 1er du mois à 9h
```

**Q. Comment gérer les logs en Shell ?**
```bash
# Rotation des logs
logrotate /etc/logrotate.conf

# Compresser les vieux logs
find /var/log -name "*.log" -mtime +7 -exec gzip {} \;

# Vider un fichier de log sans le supprimer
> /var/log/mon_app.log
truncate -s 0 /var/log/mon_app.log
```

---

## 4️⃣ Questions Avancées

**Q. Comment trier et dédupliquer une liste ?**
```bash
cat liste.txt | sort | uniq
cat liste.txt | sort -u           # Alternative
```

**Q. Comment extraire une colonne spécifique ?**
```bash
# Colonne 3 séparée par des espaces
awk '{print $3}' fichier.txt

# Colonne 2 séparée par des virgules
cut -d',' -f2 fichier.csv

# Colonne IP d'un fichier de log Nginx
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn
```

**Q. Comment vérifier si un fichier existe ?**
```bash
#!/bin/bash
FICHIER="/etc/nginx/nginx.conf"

if [ -f "$FICHIER" ]; then
    echo "✅ Le fichier existe"
elif [ -d "$FICHIER" ]; then
    echo "C'est un dossier"
else
    echo "❌ Le fichier n'existe pas"
fi

# Tests utiles :
# -f → fichier ordinaire
# -d → dossier
# -e → existe (fichier ou dossier)
# -r → lisible
# -w → modifiable
# -x → exécutable
# -s → non vide
```

**Q. Comment capturer et gérer les erreurs dans un script ?**
```bash
#!/bin/bash
set -e          # Arrêter si erreur
set -u          # Erreur si variable non définie
set -o pipefail # Capturer erreurs dans les pipes

# Trap pour nettoyer en cas d'erreur
trap 'echo "ERREUR ligne $LINENO"; exit 1' ERR

echo "Script en cours..."
commande_qui_peut_echouer || echo "Commande échouée mais on continue"
```

**Q. Comment passer des arguments à un script ?**
```bash
#!/bin/bash
# Appel : ./script.sh leonel 25 devops

echo "Nom : $1"        # Premier argument
echo "Age : $2"        # Deuxième argument
echo "Role : $3"       # Troisième argument
echo "Tous : $@"       # Tous les arguments
echo "Nombre : $#"     # Nombre d'arguments
echo "Script : $0"     # Nom du script
```

---

## 5️⃣ Conseils pour l'Entretien DevOps

```
✅ Toujours commenter son code
✅ Utiliser set -e pour stopper les scripts en cas d'erreur
✅ Tester ses scripts avec des jeux de données limités
✅ Utiliser des variables plutôt que des valeurs en dur
✅ Gérer les cas d'erreur (fichier absent, service inactif)
✅ Utiliser shellcheck pour valider ses scripts
✅ Savoir expliquer chaque commande ligne par ligne
```

---

## ✅ Nos Scripts dans la Formation

```
✅ deploy.sh       → Déploiement automatique Jour 09
✅ stop_app.sh     → Arrêt Gunicorn Jour 22
✅ install_deps.sh → Installation dépendances Jour 22
✅ validate.sh     → Validation service Jour 22
✅ monitoring.sh   → Surveillance système Jour 14-15
```

---

## ➡️ Prochain Jour

[Jour 26 — Projet : Automatiser la Surveillance AWS avec Shell](../jour-26-projet-shell-surveillance-aws/)
