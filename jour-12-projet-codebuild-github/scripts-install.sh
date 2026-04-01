#!/bin/bash
# ============================================================
# install.sh - Script BeforeInstall CodeDeploy
# Jour 12 - Projet Pratique AWS CodeBuild + GitHub
# ============================================================
echo "=== Installation des dependances ==="
cd /home/ubuntu/flaskapp
pip install -r requirements.txt
echo "Installation terminee ✓"
