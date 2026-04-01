# Jour 22 - Pipeline CI/CD Complet : Django Invoice sur AWS EC2

Date : 1 avril 2026
Statut : Completed avec preuve

## Objectif

Deployer une vraie application Django en production sur AWS EC2 avec pipeline CI/CD :

GitHub Push -> GitHub Actions -> SSH -> EC2 -> git pull -> restart

## Application Live

URL : http://44.222.105.23
Titre : LEONEL INVOICE SYSTEM
Stack : Django 6.0.3 + Gunicorn + Nginx + AWS EC2

## Pipeline CI/CD - Preuve

Run #4 : ci test pipeline avec cle ED25519
Status : SUCCESS
Duree  : 23 secondes
Date   : 1 avril 2026 14h06 UTC
URL    : https://github.com/leopen10/django-invoice/actions/runs/23847734244

## Stack Technique

- Django 6.0.3
- Gunicorn 25.3.0 (2 workers)
- Nginx 1.24.0 (reverse proxy)
- AWS EC2 t3.micro Ubuntu 24.04 us-east-1
- GitHub Actions CI/CD
- SSH ED25519 (authentification securisee)
- SQLite

## Services en Production

Gunicorn :
  Active : active (running)
  Workers: 2 processus
  Socket : unix:/home/ubuntu/django-invoice/gunicorn.sock
  Memory : 89.4 MB

Nginx :
  Active : active (running)
  Config : /etc/nginx/sites-available/django-invoice
  Static : /home/ubuntu/django-invoice/staticfiles/

## Workflow GitHub Actions

name: Deploy LEONEL INVOICE SYSTEM

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy sur EC2 via SSH
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: 44.222.105.23
          username: ubuntu
          key: EC2_SSH_KEY (secret GitHub)
          script:
            cd /home/ubuntu/django-invoice
            git pull origin main
            pip install -r requirements.txt
            python manage.py migrate --noinput
            python manage.py collectstatic --noinput
            sudo systemctl restart gunicorn
            sudo systemctl restart nginx

## Personnalisations Effectuees

- HOOYIA INVOICE SYSTEM -> LEONEL INVOICE SYSTEM
- Donald Programmer -> Leonel-Magloire PENGOU MBA
- Repo : https://github.com/leopen10/django-invoice

## Liens

- Site live : http://44.222.105.23
- Repo django-invoice : https://github.com/leopen10/django-invoice
- Pipeline : https://github.com/leopen10/django-invoice/actions
