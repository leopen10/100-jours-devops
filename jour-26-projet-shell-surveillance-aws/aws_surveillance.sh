#!/bin/bash
REGION="us-east-1"
RAPPORT="/tmp/rapport-aws-$(date +%Y-%m-%d).txt"
DATE=$(date "+%Y-%m-%d %H:%M:%S")
log() { echo "$1" | tee -a $RAPPORT; }
echo "" > $RAPPORT
log "=== RAPPORT AWS LEONEL DEVOPS - $DATE ==="
log ""
log "--- EC2 INSTANCES ---"
aws ec2 describe-instances --region $REGION --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PublicIpAddress]" --output table 2>/dev/null | tee -a $RAPPORT || log "Aucune instance"
log ""
log "--- S3 BUCKETS ---"
aws s3 ls 2>/dev/null | tee -a $RAPPORT || log "Aucun bucket"
log ""
log "--- IAM UTILISATEURS ---"
aws iam list-users --query "Users[*].[UserName,CreateDate]" --output table 2>/dev/null | tee -a $RAPPORT || log "Aucun utilisateur"
log ""
log "--- EBS VOLUMES NON ATTACHES ---"
aws ec2 describe-volumes --region $REGION --filters "Name=status,Values=available" --query "Volumes[*].[VolumeId,Size]" --output table 2>/dev/null | tee -a $RAPPORT || log "Aucun volume non attache"
log ""
log "=== RAPPORT TERMINE - $(date) ==="
cat $RAPPORT
