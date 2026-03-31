#!/bin/bash
# ============================================================
# Jour 03 - Deployer une Application Statique avec Nginx
# Script de deploiement complet
# ============================================================

echo "=========================================="
echo " JOUR 03 - Deploiement App Statique Nginx"
echo "=========================================="

# ----- ETAPE 1 : Mise a jour du systeme -----
echo ""
echo ">>> ETAPE 1 : Mise a jour du systeme..."
sudo apt update -y
echo "Systeme mis a jour ✓"

# ----- ETAPE 2 : Installation de Nginx -----
echo ""
echo ">>> ETAPE 2 : Installation de Nginx..."
sudo apt install -y nginx
echo "Nginx installe ✓"

# ----- ETAPE 3 : Demarrer et activer Nginx -----
echo ""
echo ">>> ETAPE 3 : Demarrage de Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx --no-pager
echo "Nginx demarre et active au demarrage ✓"

# ----- ETAPE 4 : Creer la structure du site -----
echo ""
echo ">>> ETAPE 4 : Creation de la structure du site..."
sudo mkdir -p /var/www/html/devops-portfolio
echo "Dossier cree : /var/www/html/devops-portfolio ✓"

# ----- ETAPE 5 : Copier les fichiers du site -----
echo ""
echo ">>> ETAPE 5 : Copie des fichiers du site..."
# Copier le fichier index.html dans le dossier web
sudo cp index.html /var/www/html/devops-portfolio/
echo "Fichiers copies ✓"

# ----- ETAPE 6 : Configurer les permissions -----
echo ""
echo ">>> ETAPE 6 : Configuration des permissions..."
sudo chown -R www-data:www-data /var/www/html/devops-portfolio
sudo chmod -R 755 /var/www/html/devops-portfolio
ls -la /var/www/html/devops-portfolio/
echo "Permissions configurees ✓"

# ----- ETAPE 7 : Configurer le virtual host Nginx -----
echo ""
echo ">>> ETAPE 7 : Configuration du virtual host Nginx..."
sudo tee /etc/nginx/sites-available/devops-portfolio > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    root /var/www/html/devops-portfolio;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Logs
    access_log /var/log/nginx/devops-portfolio-access.log;
    error_log /var/log/nginx/devops-portfolio-error.log;
}
EOF
echo "Virtual host configure ✓"

# ----- ETAPE 8 : Activer le site -----
echo ""
echo ">>> ETAPE 8 : Activation du site..."
sudo ln -sf /etc/nginx/sites-available/devops-portfolio /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
echo "Site active ✓"

# ----- ETAPE 9 : Tester la config Nginx -----
echo ""
echo ">>> ETAPE 9 : Test de la configuration Nginx..."
sudo nginx -t

# ----- ETAPE 10 : Recharger Nginx -----
echo ""
echo ">>> ETAPE 10 : Rechargement de Nginx..."
sudo systemctl reload nginx
echo "Nginx recharge ✓"

# ----- VERIFICATION FINALE -----
echo ""
echo "=========================================="
echo " VERIFICATION FINALE"
echo "=========================================="
echo "Status Nginx :"
sudo systemctl status nginx --no-pager | head -5

echo ""
echo "Fichiers deployes :"
ls -la /var/www/html/devops-portfolio/

echo ""
echo "Test local :"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/

echo ""
echo "=========================================="
echo " DEPLOIEMENT TERMINE !"
echo " Ouvre ton navigateur sur : http://[IP-SERVEUR]"
echo "=========================================="
