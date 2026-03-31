#!/bin/bash
# ============================================================
# Jour 04 - Exercices Pratiques Vim et Nano
# A executer sur ton serveur EC2 Ubuntu
# ============================================================

echo "=========================================="
echo " JOUR 04 - Editeurs de Texte Linux"
echo "=========================================="

# ----- EXERCICE 1 : Nano -----
echo ""
echo ">>> EXERCICE 1 : Creer un fichier avec Nano"
echo "Commande : nano ~/devops-notes.txt"
echo "1. Tape du texte"
echo "2. Ctrl+O pour sauvegarder"
echo "3. Ctrl+X pour quitter"
echo ""

# Creer automatiquement un fichier de demo
cat > ~/devops-notes.txt << 'EOF'
# DevOps Notes - Jour 4
# Editeurs de texte Linux

## Nano
- Ctrl+O : Sauvegarder
- Ctrl+X : Quitter
- Ctrl+W : Rechercher
- Ctrl+K : Couper ligne
- Ctrl+U : Coller

## Vim
- i      : Mode INSERT
- Esc    : Mode NORMAL
- :w     : Sauvegarder
- :q     : Quitter
- :wq    : Sauvegarder et quitter
- :q!    : Quitter sans sauvegarder
- dd     : Supprimer ligne
- yy     : Copier ligne
- p      : Coller
- /mot   : Rechercher
EOF

echo "Fichier devops-notes.txt cree !"
cat ~/devops-notes.txt

# ----- EXERCICE 2 : Vim - Creer un script -----
echo ""
echo ">>> EXERCICE 2 : Creer un script Bash avec Vim"
echo "Commande : vim ~/mon-premier-script.sh"
echo ""

cat > ~/mon-premier-script.sh << 'EOF'
#!/bin/bash
# Script cree avec Vim - Jour 4
echo "Hello DevOps !"
echo "Date : $(date)"
echo "Utilisateur : $(whoami)"
echo "Serveur : $(hostname)"
EOF

chmod +x ~/mon-premier-script.sh
echo "Script cree et executable !"
bash ~/mon-premier-script.sh

# ----- EXERCICE 3 : Modifier config Nginx -----
echo ""
echo ">>> EXERCICE 3 : Modifier la config Nginx avec Vim"
echo "Commande : sudo vim /etc/nginx/sites-available/devops-portfolio"
echo ""
echo "Dans Vim :"
echo "  1. /server_name  pour trouver la ligne"
echo "  2. i pour passer en mode INSERT"
echo "  3. Modifier la valeur"
echo "  4. Esc puis :wq pour sauvegarder"
echo ""

# Verifier que Nginx est configure
if [ -f /etc/nginx/sites-available/devops-portfolio ]; then
    echo "Config Nginx trouvee :"
    cat /etc/nginx/sites-available/devops-portfolio
else
    echo "Config Nginx non trouvee - deploie d'abord le Jour 3 !"
fi

# ----- EXERCICE 4 : Vim - Recherche et remplacement -----
echo ""
echo ">>> EXERCICE 4 : Recherche et remplacement dans Vim"
echo ""
echo "Ouvre le fichier avec vim ~/devops-notes.txt"
echo "Puis dans Vim mode NORMAL :"
echo "  :%s/Nano/NANO/g   -> Remplace tous les 'Nano' par 'NANO'"
echo "  :w                 -> Sauvegarder"
echo "  :q                 -> Quitter"

# ----- EXERCICE 5 : .vimrc - Personnaliser Vim -----
echo ""
echo ">>> EXERCICE 5 : Personnaliser Vim avec .vimrc"

cat > ~/.vimrc << 'EOF'
" Configuration Vim pour DevOps
set number          " Afficher les numeros de ligne
set syntax=on       " Coloration syntaxique
set tabstop=4       " Tabulation = 4 espaces
set expandtab       " Convertir tabs en espaces
set autoindent      " Indentation automatique
set hlsearch        " Surligner les resultats de recherche
set incsearch       " Recherche en temps reel
colorscheme desert  " Theme de couleur
EOF

echo ".vimrc configure ! Vim est maintenant personnalise."
echo ""

# ----- RECAP -----
echo "=========================================="
echo " RECAP DES FICHIERS CREES"
echo "=========================================="
ls -la ~/devops-notes.txt ~/mon-premier-script.sh ~/.vimrc
echo ""
echo "Jour 04 termine - Tu maitrises Nano et Vim !"
