#!/bin/bash
URL="http://44.222.105.23"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)
DATE=$(date "+%Y-%m-%d %H:%M:%S")
if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "302" ]; then
    echo "[$DATE] Site OK - HTTP $HTTP_CODE"
else
    echo "[$DATE] ALERTE - HTTP $HTTP_CODE"
fi
