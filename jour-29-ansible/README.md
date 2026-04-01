# Jour 29 — Ansible : Automatisation et Gestion de Configuration 🔧

> ⏱️ Durée : 45 min | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Pourquoi la Gestion de Configuration ?

```
Sans Ansible                    Avec Ansible
────────────────────            ────────────────────
SSH sur 100 serveurs manuels → 1 commande pour tous
Configurations différentes   → Configurations standardisées
Pas de traçabilité           → Infrastructure as Code
Erreurs humaines fréquentes  → Reproductible et fiable
```

---

## ⚡ Ansible vs Puppet vs Chef

| Critère | Ansible | Puppet | Chef |
|---------|---------|--------|------|
| **Mode** | Push (sans agent) | Pull (avec agent) | Pull (avec agent) |
| **Langage** | YAML simple | DSL Puppet | Ruby DSL |
| **Installation** | Rien sur les serveurs | Agent requis | Agent requis |
| **Courbe apprentissage** | Facile | Complexe | Complexe |
| **Popularité DevOps** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |

**Ansible gagne** car : sans agent, YAML simple, SSH suffisant.

---

## 🏗️ Architecture Ansible

```
Machine de Contrôle (ton PC ou un serveur CI/CD)
           ↓ SSH
    Inventaire (liste des serveurs)
           ↓
    Playbooks (instructions YAML)
           ↓
┌──────────────────────────────┐
│  Serveur 1   Serveur 2   ... │
│  (Ubuntu)    (CentOS)        │
└──────────────────────────────┘
```

---

## 📦 Installation Ansible

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ansible -y

# Vérifier
ansible --version
```

---

## 📋 Inventaire (inventory.ini)

```ini
# inventory.ini - Liste des serveurs à gérer

[webservers]
web1 ansible_host=44.222.105.23 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/devops-jour3-key.pem
web2 ansible_host=52.123.456.789 ansible_user=ubuntu

[databases]
db1 ansible_host=10.0.0.5 ansible_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

---

## 📄 Playbook — Premier exemple

```yaml
# deploy.yml - Déployer Nginx
---
- name: Installer et configurer Nginx
  hosts: webservers
  become: true   # sudo

  tasks:
    - name: Mettre à jour apt
      apt:
        update_cache: yes

    - name: Installer Nginx
      apt:
        name: nginx
        state: present

    - name: Démarrer Nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Copier le fichier de config
      copy:
        src: ./nginx.conf
        dest: /etc/nginx/sites-available/default
        mode: '0644'
      notify: Reload Nginx

  handlers:
    - name: Reload Nginx
      service:
        name: nginx
        state: reloaded
```

### Exécuter le playbook
```bash
# Syntaxe de base
ansible-playbook -i inventory.ini deploy.yml

# Avec vérification avant exécution
ansible-playbook -i inventory.ini deploy.yml --check

# Verbose pour debug
ansible-playbook -i inventory.ini deploy.yml -v
```

---

## 🔧 Modules Ansible Essentiels

### Gestion des paquets
```yaml
- name: Installer Python et pip
  apt:
    name:
      - python3
      - python3-pip
      - gunicorn
    state: present
    update_cache: yes
```

### Gestion des fichiers
```yaml
- name: Copier le fichier de config
  copy:
    src: ./config.py
    dest: /home/ubuntu/app/config.py
    owner: ubuntu
    group: ubuntu
    mode: '0644'

- name: Créer un dossier
  file:
    path: /home/ubuntu/app/logs
    state: directory
    owner: ubuntu
    mode: '0755'
```

### Gestion des services
```yaml
- name: Redémarrer Gunicorn
  service:
    name: gunicorn
    state: restarted
    enabled: yes
```

### Exécuter des commandes
```yaml
- name: Faire les migrations Django
  command: python manage.py migrate --noinput
  args:
    chdir: /home/ubuntu/django-invoice
  become_user: ubuntu
```

### Git
```yaml
- name: Cloner le repo
  git:
    repo: git@github.com:leopen10/django-invoice.git
    dest: /home/ubuntu/django-invoice
    version: main
    force: yes
```

---

## 🎭 Roles Ansible

Un **Role** organise les playbooks en structure réutilisable :

```
roles/
└── django_app/
    ├── tasks/
    │   └── main.yml      ← Tâches principales
    ├── handlers/
    │   └── main.yml      ← Handlers (reload, restart)
    ├── templates/
    │   └── gunicorn.service.j2  ← Templates Jinja2
    ├── files/
    │   └── nginx.conf    ← Fichiers statiques
    └── vars/
        └── main.yml      ← Variables du role
```

---

## 🚀 Playbook Complet — Déployer Django

```yaml
# deploy_django.yml
---
- name: Deployer LEONEL INVOICE SYSTEM
  hosts: webservers
  become: true
  vars:
    app_dir: /home/ubuntu/django-invoice
    venv_dir: /home/ubuntu/venv-devops
    repo_url: git@github.com:leopen10/django-invoice.git

  tasks:
    - name: Installer dependances systeme
      apt:
        name:
          - python3
          - python3-pip
          - nginx
          - git
        state: present
        update_cache: yes

    - name: Cloner le repo
      git:
        repo: "{{ repo_url }}"
        dest: "{{ app_dir }}"
        version: main

    - name: Installer dependances Python
      pip:
        requirements: "{{ app_dir }}/requirements.txt"
        virtualenv: "{{ venv_dir }}"

    - name: Migrations Django
      command: "{{ venv_dir }}/bin/python manage.py migrate --noinput"
      args:
        chdir: "{{ app_dir }}"

    - name: Collectstatic
      command: "{{ venv_dir }}/bin/python manage.py collectstatic --noinput"
      args:
        chdir: "{{ app_dir }}"

    - name: Redémarrer Gunicorn
      service:
        name: gunicorn
        state: restarted

    - name: Redémarrer Nginx
      service:
        name: nginx
        state: restarted
```

---

## 🔄 Ansible vs Notre Pipeline GitHub Actions

| Action | GitHub Actions (Jour 22) | Ansible |
|--------|--------------------------|---------|
| git pull | ✅ Dans le script SSH | ✅ Module git |
| pip install | ✅ Dans le script | ✅ Module pip |
| migrate | ✅ Dans le script | ✅ Module command |
| restart | ✅ sudo systemctl | ✅ Module service |
| **Avantage** | Simple, intégré CI/CD | Multi-serveurs, idempotent |

**Ansible brille** quand on gère **10+ serveurs** simultanément !

---

## ✅ Commandes Ansible Utiles

```bash
# Tester la connexion à tous les serveurs
ansible all -i inventory.ini -m ping

# Exécuter une commande sur tous les serveurs
ansible webservers -i inventory.ini -m command -a "uptime"

# Vérifier l'espace disque sur tous les serveurs
ansible all -i inventory.ini -m shell -a "df -h"

# Copier un fichier
ansible webservers -i inventory.ini -m copy \
    -a "src=./app.py dest=/home/ubuntu/app.py"
```

---

## ➡️ Prochain Jour

[Jour 30 — Terraform : Infrastructure as Code](../jour-30-terraform/)
