# Jour 02 — Linux pour le DevOps Partie I 🐧

> ⏱️ Durée : 1h00 | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi Linux pour le DevOps ?

- **97%** des serveurs web dans le monde tournent sous Linux
- Tous les outils DevOps majeurs (Docker, Kubernetes, Jenkins, Terraform) fonctionnent sur Linux
- Les conteneurs sont basés sur Linux — même sous Windows/Mac, Docker utilise un noyau Linux virtualisé
- Le shell (Bash/Zsh) permet d'automatiser, superviser et déployer

---

## 📁 1. Structure du Système de Fichiers Linux

```
/ → Racine du système
├── bin/   → Commandes essentielles (ls, cp, mkdir...)
├── etc/   → Fichiers de configuration système
├── home/  → Répertoires personnels des utilisateurs
├── root/  → Répertoire de l'administrateur (root)
├── tmp/   → Fichiers temporaires (effacés au redémarrage)
├── usr/   → Applications et programmes utilisateur
├── var/   → Fichiers variables (logs, bases de données...)
└── lib/   → Bibliothèques partagées essentielles
```

**Distributions Linux populaires en DevOps :**
- **Ubuntu** — La plus populaire, excellente documentation
- **CentOS/RHEL** — Standard en entreprise, très stable
- **Alpine Linux** — Légère, parfaite pour les conteneurs

---

## ⌨️ 2. Commandes Essentielles

### Navigation & Fichiers
```bash
pwd                        # Répertoire courant
ls -la                     # Liste avec détails et fichiers cachés
cd /chemin                 # Changer de répertoire
tree                       # Afficher l'arborescence
cat fichier.txt            # Afficher le contenu
less fichier.txt           # Afficher page par page (q pour quitter)
head -n 10 fichier.txt     # 10 premières lignes
tail -f fichier.log        # Suivre les logs en temps réel
```

### Création, Copie, Suppression
```bash
touch nouveau.txt          # Créer un fichier vide
mkdir nouveau_dossier      # Créer un dossier
cp source.txt dest/        # Copier un fichier
mv ancien.txt nouveau.txt  # Renommer ou déplacer
rm fichier.txt             # Supprimer (attention ! pas de corbeille)
rm -r dossier/             # Supprimer récursivement
```

### Recherche
```bash
find /home -name "*.log"         # Trouver des fichiers
grep "ERROR" /var/log/syslog     # Chercher dans un fichier
grep -r "database" /etc/         # Recherche récursive
```

---

## 🔐 3. Permissions Linux

### Comprendre chmod
```
Lecture (r)  = 4
Écriture (w) = 2
Exécution(x) = 1

chmod 755 fichier.txt
→ Propriétaire : 7 (rwx)
→ Groupe       : 5 (r-x)
→ Autres       : 5 (r-x)
```

### Commandes de permissions
```bash
ls -la fichier.txt                     # Voir les permissions
chmod 755 script.sh                    # Notation numérique
chmod u+rwx,g+rx,o+rx fichier.txt     # Notation symbolique
chmod -R 755 dossier/                  # Récursif
chown user:group fichier               # Changer propriétaire
chgrp groupe fichier                   # Changer groupe
```

---

## ⚙️ 4. Gestion des Processus

```bash
ps aux                    # Lister tous les processus
top                       # Temps réel (q pour quitter)
htop                      # Version améliorée (à installer)
kill 1234                 # Terminer le PID 1234
kill -9 1234              # Forcer la terminaison
killall nginx             # Terminer tous les processus nginx
commande &                # Lancer en arrière-plan
jobs                      # Lister les jobs en arrière-plan
fg %1                     # Ramener au premier plan
```

### Services avec systemctl
```bash
systemctl status nginx    # Statut du service
systemctl start nginx     # Démarrer
systemctl stop nginx      # Arrêter
systemctl restart nginx   # Redémarrer
systemctl enable nginx    # Démarrage automatique
journalctl -u nginx -f    # Logs en temps réel
```

---

## 👥 5. Gestion des Utilisateurs

```bash
whoami                              # Utilisateur courant
id                                  # Informations utilisateur
sudo commande                       # Exécuter en superutilisateur
sudo useradd -m -s /bin/bash user   # Créer un utilisateur
sudo passwd user                    # Définir mot de passe
sudo usermod -aG sudo user          # Ajouter au groupe sudo
sudo userdel -r user                # Supprimer utilisateur + home
```

---

## 🌐 6. Réseau et Connectivité

```bash
ping google.com                     # Tester la connectivité
curl http://example.com             # Tester une URL
wget http://example.com/file.zip    # Télécharger un fichier
netstat -tuln                       # Ports en écoute
ss -tuln                            # Version moderne de netstat
ssh -i clé.pem user@serveur         # Connexion SSH
scp -i clé.pem fichier user@ip:/    # Copie sécurisée
```

---

## 🏋️ Exercices Pratiques

Voir [`exercices/`](./exercices/) pour les 6 exercices pratiques :
- Exercice 1 : Structure sécurisée pour projet d'équipe
- Exercice 2 : Surveillance et gestion des processus
- Exercice 3 : Environnement multi-utilisateurs avec ACL
- Exercice 4 : Script de surveillance automatisée
- Exercice 5 : Configuration sudo avancée
- Exercice 6 : Gestion des permissions avec ACL

---

## ➡️ Prochain Jour

[Jour 03 — Déployer une Application Statique avec Linux](../jour-03-linux-partie2/)
