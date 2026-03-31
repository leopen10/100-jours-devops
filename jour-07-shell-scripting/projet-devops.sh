#!/bin/bash
# ============================================================
# Jour 07 - Shell Scripting Bash
# Projet : Script de monitoring et deploiement DevOps
# ============================================================

set -exo pipefail

# ===== CONFIGURATION =====
APP_NAME="devops-portfolio"
WEB_DIR="/var/www/html/${APP_NAME}"
LOG_FILE="/tmp/devops-monitor-$(date +%Y%m%d).log"
SERVICES=("nginx" "ssh")

# ===== COULEURS =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ===== FONCTIONS =====

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_service() {
    local service=$1
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "${GREEN}✅ $service : actif${NC}"
        log "SERVICE OK: $service"
    else
        echo -e "${RED}❌ $service : inactif${NC}"
        log "SERVICE KO: $service"
    fi
}

check_disk() {
    local usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
    if [ "$usage" -gt 80 ]; then
        echo -e "${RED}⚠️  Disque: ${usage}% utilisé - ALERTE !${NC}"
        log "DISK ALERT: ${usage}%"
    else
        echo -e "${GREEN}💾 Disque: ${usage}% utilisé - OK${NC}"
        log "DISK OK: ${usage}%"
    fi
}

check_memory() {
    local total=$(free | awk '/Mem:/ {print $2}')
    local used=$(free | awk '/Mem:/ {print $3}')
    local usage=$((used * 100 / total))
    if [ "$usage" -gt 85 ]; then
        echo -e "${RED}⚠️  Mémoire: ${usage}% utilisée - ALERTE !${NC}"
        log "MEMORY ALERT: ${usage}%"
    else
        echo -e "${GREEN}🧠 Mémoire: ${usage}% utilisée - OK${NC}"
        log "MEMORY OK: ${usage}%"
    fi
}

check_nginx_response() {
    local status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ 2>/dev/null)
    if [ "$status" = "200" ]; then
        echo -e "${GREEN}🌐 Site web: HTTP $status - OK${NC}"
        log "WEB OK: HTTP $status"
    else
        echo -e "${RED}❌ Site web: HTTP $status - KO${NC}"
        log "WEB KO: HTTP $status"
    fi
}

deploy_update() {
    log "Début du déploiement..."

    # Vérifier que le dossier web existe
    if [ ! -d "$WEB_DIR" ]; then
        sudo mkdir -p "$WEB_DIR"
        log "Dossier web créé: $WEB_DIR"
    fi

    # Créer une page de mise à jour
    sudo tee "$WEB_DIR/update.html" > /dev/null << EOF
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Update - DevOps Portfolio</title></head>
<body style="background:#0d1117;color:#e6edf3;font-family:Arial;text-align:center;padding:50px">
<h1>🚀 Déploiement automatisé</h1>
<p>Mis à jour le : $(date)</p>
<p>Serveur : $(hostname)</p>
<p>Script : $0</p>
</body></html>
EOF
    log "Fichier update.html déployé"

    # Recharger Nginx si disponible
    if systemctl is-active --quiet nginx 2>/dev/null; then
        sudo systemctl reload nginx
        log "Nginx rechargé"
    fi

    log "Déploiement terminé ✓"
}

# ===== TRAP - NETTOYAGE =====
trap 'log "Script interrompu !"; exit 1' SIGINT SIGTERM
trap 'log "Script terminé. Log: $LOG_FILE"' EXIT

# ===== MAIN =====
echo ""
echo "=========================================="
echo " JOUR 07 - Script DevOps Complet"
echo " $(date)"
echo "=========================================="
echo ""

log "=== Démarrage du monitoring ==="

# 1. Vérification des services
echo ">>> Vérification des services..."
for service in "${SERVICES[@]}"; do
    check_service "$service"
done

# 2. Ressources système
echo ""
echo ">>> Ressources système..."
check_disk
check_memory
echo -e "🖥️  CPUs: $(nproc) cores"
echo -e "⏱️  Uptime: $(uptime -p)"

# 3. Test du site web
echo ""
echo ">>> Test du site web..."
check_nginx_response

# 4. Déploiement
echo ""
echo ">>> Déploiement d'une mise à jour..."
deploy_update

# 5. Recherche d'erreurs dans les logs
echo ""
echo ">>> Analyse des logs Nginx..."
if [ -f "/var/log/nginx/error.log" ]; then
    NB_ERREURS=$(grep -c "error" /var/log/nginx/error.log 2>/dev/null || echo "0")
    echo -e "📋 Erreurs Nginx: $NB_ERREURS"
    log "NGINX ERRORS: $NB_ERREURS"
else
    echo "Logs Nginx non disponibles"
fi

# 6. Rapport final
echo ""
echo "=========================================="
echo " RAPPORT FINAL"
echo "=========================================="
echo "Serveur   : $(hostname)"
echo "IP        : $(hostname -I | awk '{print $1}')"
echo "Date      : $(date)"
echo "Log       : $LOG_FILE"
echo "Script PID: $$"
echo ""
echo "Contenu du log :"
cat "$LOG_FILE"
echo ""
echo "✅ Script Jour 07 terminé avec succès !"
