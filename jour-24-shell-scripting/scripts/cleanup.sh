#!/bin/bash
echo "=== NETTOYAGE LOGS ==="
echo "Avant : $(du -sh /var/log/ 2>/dev/null | cut -f1)"
find /var/log -name "*.gz" -mtime +7 -delete 2>/dev/null
find /tmp -mtime +3 -delete 2>/dev/null || true
echo "Apres : $(du -sh /var/log/ 2>/dev/null | cut -f1)"
echo "Nettoyage termine !"
