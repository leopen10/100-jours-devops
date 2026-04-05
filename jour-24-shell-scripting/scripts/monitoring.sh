#!/bin/bash
DATE=$(date "+%Y-%m-%d %H:%M:%S")
LOG="/tmp/monitoring.log"
echo "=== MONITORING - $DATE ===" | tee -a $LOG
echo "CPU : $(top -bn1 | grep Cpu | awk "{print \$2}")%" | tee -a $LOG
echo "RAM : $(free -h | grep Mem | awk "{print \$3 \"/\" \$2}")" | tee -a $LOG
echo "DISK: $(df -h / | tail -1 | awk "{print \$5}")" | tee -a $LOG
echo "UPTIME: $(uptime -p)" | tee -a $LOG
for SERVICE in nginx gunicorn; do
  systemctl is-active --quiet $SERVICE && echo "$SERVICE: OK" | tee -a $LOG || echo "$SERVICE: INACTIF" | tee -a $LOG
done
echo "Log: $LOG"
