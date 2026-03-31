#!/bin/bash
# ============================================================
# Jour 02 — Linux pour le DevOps Partie I
# Commandes essentielles pratiquées
# ============================================================

echo "=== NAVIGATION & FICHIERS ==="
pwd
ls -la
# cd /home

echo ""
echo "=== LECTURE DE FICHIERS ==="
# cat fichier.txt
# less fichier.txt
# head -n 10 fichier.txt
# tail -f fichier.log

echo ""
echo "=== CREATION & SUPPRESSION ==="
touch test-devops.txt
mkdir -p projet-devops/{dev,prod,logs}
ls -la
echo "Hello DevOps" > test-devops.txt
cat test-devops.txt
cp test-devops.txt projet-devops/dev/
ls projet-devops/dev/
# Nettoyage
rm test-devops.txt
rm -rf projet-devops/

echo ""
echo "=== RECHERCHE ==="
find /tmp -name "*.txt" 2>/dev/null | head -5
# grep "ERROR" /var/log/syslog

echo ""
echo "=== PERMISSIONS ==="
touch script-test.sh
echo '#!/bin/bash\necho "Script DevOps"' > script-test.sh
ls -la script-test.sh
chmod 755 script-test.sh
ls -la script-test.sh
rm script-test.sh

echo ""
echo "=== PROCESSUS ==="
ps aux | head -10
echo "PID du shell courant: $$"

echo ""
echo "=== RESEAU ==="
# ping -c 3 google.com
# curl -I http://example.com

echo ""
echo "=== UTILISATEURS ==="
whoami
id
groups

echo ""
echo "=== SCRIPT DE SURVEILLANCE ==="
cat << 'EOF'
#!/bin/bash
# surveillance-processus.sh
SERVICES=("nginx" "mysql" "ssh")
for service in "${SERVICES[@]}"; do
    if pgrep -x "$service" > /dev/null; then
        echo "✅ $service est en cours d'exécution"
    else
        echo "❌ ALERTE: $service n'est pas en cours d'exécution!"
    fi
done

# Surveillance mémoire
MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')
echo "📊 Utilisation mémoire: $MEM_USAGE%"
if [ "$MEM_USAGE" -gt 90 ]; then
    echo "⚠️  ALERTE: Mémoire élevée!"
fi
EOF

echo ""
echo "✅ Jour 02 terminé — Linux pour le DevOps Partie I"
