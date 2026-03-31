# Jour 04 — Les Éditeurs de Texte Linux 📝

> ⏱️ Durée : 30 min | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi maîtriser les éditeurs Linux ?

En DevOps, tu passes ta vie à éditer des fichiers de config sur des serveurs distants **sans interface graphique**. Maîtriser Nano et Vim est **indispensable** pour :
- Modifier des configs Nginx, Docker, Kubernetes
- Éditer des scripts Bash
- Corriger des fichiers en production sous SSH

---

## 📝 1. NANO — L'éditeur débutant-friendly

### Ouvrir/créer un fichier
```bash
nano fichier.txt
nano /etc/nginx/sites-available/monsite
```

### Commandes essentielles (affichées en bas de l'écran)
| Raccourci | Action |
|-----------|--------|
| `Ctrl+O` | Sauvegarder (Write Out) |
| `Ctrl+X` | Quitter |
| `Ctrl+W` | Rechercher |
| `Ctrl+K` | Couper une ligne |
| `Ctrl+U` | Coller |
| `Ctrl+G` | Aide |
| `Alt+U`  | Annuler |

### Avantages
- ✅ Facile à utiliser dès le début
- ✅ Raccourcis visibles à l'écran
- ✅ Parfait pour des modifications rapides

---

## ⚡ 2. VIM — L'éditeur des pros

### Les 3 modes de Vim
```
NORMAL  → Navigation + commandes (mode par défaut)
INSERT  → Écriture du texte
VISUAL  → Sélection de texte
```

### Ouvrir Vim
```bash
vim fichier.txt
vi fichier.txt    # version plus ancienne
```

### Commandes essentielles

#### Mode NORMAL → INSERT
```
i    → Insérer avant le curseur
a    → Insérer après le curseur
o    → Nouvelle ligne en dessous
I    → Insérer au début de la ligne
A    → Insérer à la fin de la ligne
```

#### Retour au mode NORMAL
```
Echap (Esc)
```

#### Sauvegarder et quitter (mode NORMAL)
```
:w        → Sauvegarder
:q        → Quitter
:wq       → Sauvegarder et quitter
:q!       → Quitter sans sauvegarder (forcer)
:wq!      → Sauvegarder et quitter (forcer)
```

#### Navigation (mode NORMAL)
```
h, j, k, l  → Gauche, Bas, Haut, Droite
gg           → Début du fichier
G            → Fin du fichier
0            → Début de ligne
$            → Fin de ligne
:n           → Aller à la ligne n (ex: :42)
```

#### Édition (mode NORMAL)
```
dd      → Supprimer la ligne courante
yy      → Copier la ligne courante
p       → Coller après le curseur
u       → Annuler
Ctrl+r  → Refaire
/mot    → Rechercher "mot"
n       → Occurrence suivante
:%s/ancien/nouveau/g  → Remplacer tout
```

---

## 🔧 3. Projet Pratique — Configurer Nginx avec Vim

### Exercice réalisé sur le serveur EC2 (Jour 3)

```bash
# 1. Ouvrir la config Nginx avec Vim
sudo vim /etc/nginx/sites-available/devops-portfolio

# 2. Naviguer jusqu'à la ligne "server_name"
/server_name

# 3. Modifier avec 'i' pour passer en mode INSERT
# Changer _ par l'IP du serveur

# 4. Sauvegarder et quitter
:wq

# 5. Tester la config
sudo nginx -t

# 6. Recharger
sudo systemctl reload nginx
```

### Exercice avec Nano

```bash
# Créer un fichier de notes avec Nano
nano ~/devops-notes.txt

# Écrire :
# DevOps - Notes Jour 4
# Nano : Ctrl+O pour sauvegarder, Ctrl+X pour quitter
# Vim  : :wq pour sauvegarder et quitter

# Ctrl+O → Enter → Ctrl+X pour sauvegarder et quitter
```

---

## 💡 Nano vs Vim — Quand utiliser lequel ?

| Situation | Éditeur recommandé |
|-----------|-------------------|
| Modification rapide d'un fichier | **Nano** |
| Travail intensif sur du code | **Vim** |
| Débutant | **Nano** |
| Sur un serveur minimal (pas de Nano) | **Vi/Vim** |
| Remplacement de texte en masse | **Vim** |
| Entretien technique DevOps | **Vim** ⭐ |

---

## 🏋️ Exercices Pratiques

Voir [`exercices.sh`](./exercices.sh) pour les exercices complets.

---

## ➡️ Prochain Jour

[Jour 05 — Bash Scripting](../jour-05-bash-scripting/)
