#!/bin/bash
# ================================================================
# aws_surveillance.sh - Surveillance AWS et Rapport Quotidien
# Jour 26 - Formation DevOps 100 Jours
# Auteur : Leonel-Magloire PENGOU MBA
# Date   : 1 avril 2026
# ================================================================

set -e

# ── Configuration ──────────────────────────────────────────────
REGION="us-east-1"
RAPPORT="/tmp/rapport-aws-$(date +%Y-%m-%d).txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# ── Fonctions ──────────────────────────────────────────────────
log() {
    echo "$1" | tee -a $RAPPORT
}

separateur() {
    log "─────────────────────────────────────────────"
}

# ── En-tête du rapport ─────────────────────────────────────────
echo "" > $RAPPORT
log "================================================================"
log "   RAPPORT DE SURVEILLANCE AWS - LEONEL DEVOPS"
log "   Date : $DATE"
log "   Region : $REGION"
log "================================================================"
echo ""

# ── 1. Instances EC2 ───────────────────────────────────────────
log ""
log "📦 INSTANCES EC2"
separateur

EC2_LIST=$(aws ec2 describe-instances \
    --region $REGION \
    --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PublicIpAddress]' \
    --output text 2>/dev/null)

if [ -z "$EC2_LIST" ]; then
    log "Aucune instance EC2 trouvee"
else
    log "ID Instance       | Etat    | Type      | IP Publique"
    separateur
    echo "$EC2_LIST" | while read LINE; do
        log "$LINE"
    done
fi

# Instances arrêtées (gaspillage potentiel)
EC2_STOPPED=$(aws ec2 describe-instances \
    --region $REGION \
    --filters "Name=instance-state-name,Values=stopped" \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text 2>/dev/null)

if [ ! -z "$EC2_STOPPED" ]; then
    log ""
    log "⚠️  INSTANCES ARRETEES (couts potentiels EBS) :"
    log "$EC2_STOPPED"
fi

# ── 2. Buckets S3 ──────────────────────────────────────────────
log ""
log "🪣 BUCKETS S3"
separateur

S3_LIST=$(aws s3 ls 2>/dev/null)
if [ -z "$S3_LIST" ]; then
    log "Aucun bucket S3 trouve"
else
    S3_COUNT=$(echo "$S3_LIST" | wc -l)
    log "Total buckets : $S3_COUNT"
    log ""
    echo "$S3_LIST" | while read LINE; do
        log "$LINE"
    done
fi

# ── 3. Utilisateurs IAM ────────────────────────────────────────
log ""
log "👤 UTILISATEURS IAM"
separateur

IAM_LIST=$(aws iam list-users \
    --query 'Users[*].[UserName,CreateDate]' \
    --output text 2>/dev/null)

if [ -z "$IAM_LIST" ]; then
    log "Aucun utilisateur IAM trouve"
else
    IAM_COUNT=$(echo "$IAM_LIST" | wc -l)
    log "Total utilisateurs : $IAM_COUNT"
    log ""
    echo "$IAM_LIST" | while read LINE; do
        log "$LINE"
    done
fi

# ── 4. Fonctions Lambda ────────────────────────────────────────
log ""
log "⚡ FONCTIONS LAMBDA"
separateur

LAMBDA_LIST=$(aws lambda list-functions \
    --region $REGION \
    --query 'Functions[*].[FunctionName,Runtime,LastModified]' \
    --output text 2>/dev/null)

if [ -z "$LAMBDA_LIST" ]; then
    log "Aucune fonction Lambda trouvee"
else
    LAMBDA_COUNT=$(echo "$LAMBDA_LIST" | wc -l)
    log "Total fonctions : $LAMBDA_COUNT"
    log ""
    echo "$LAMBDA_LIST" | while read LINE; do
        log "$LINE"
    done
fi

# ── 5. Groupes de Sécurité non utilisés ───────────────────────
log ""
log "🔐 GROUPES DE SECURITE"
separateur

SG_LIST=$(aws ec2 describe-security-groups \
    --region $REGION \
    --query 'SecurityGroups[*].[GroupId,GroupName,Description]' \
    --output text 2>/dev/null)

SG_COUNT=$(echo "$SG_LIST" | wc -l)
log "Total groupes : $SG_COUNT"

# ── 6. Résumé et Recommandations ──────────────────────────────
log ""
log "================================================================"
log "   RESUME ET RECOMMANDATIONS"
log "================================================================"
log ""

if [ ! -z "$EC2_STOPPED" ]; then
    log "⚠️  Des instances EC2 sont arretees mais consomment du stockage EBS"
    log "   → Supprimer les volumes EBS inutilises pour reduire les couts"
fi

log "✅ Rapport genere avec succes"
log "📄 Rapport sauvegarde : $RAPPORT"
log "🕐 Prochaine execution : $(date -d 'tomorrow 18:00' '+%Y-%m-%d 18:00:00')"
log ""
log "================================================================"

echo ""
echo "Rapport disponible : $RAPPORT"
cat $RAPPORT
