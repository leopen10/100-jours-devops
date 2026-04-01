# Jour 30 - Ansible Zero to Hero

> Date : 1 avril 2026 | Statut : Completed avec preuve

## Commandes Ad-Hoc testees
```bash
ansible local -i inventory.ini -m command -a "uptime"
ansible local -i inventory.ini -m command -a "df -h /"
ansible local -i inventory.ini -m command -a "free -h"
ansible local -i inventory.ini -m service -a "name=nginx state=started" --become
```

## Playbook avance - Rapport systeme
```
PLAY RECAP : ok=5  changed=1  failed=0

Host : ip-172-31-78-7
OS   : Ubuntu 24.04
IP   : 172.31.78.7
CPUs : 2
Disk : 6.8G total 4.0G used 2.8G avail 59%
RAM  : 911Mi total 638Mi used
```

## Prochain Jour
Jour 31 - Introduction a Terraform et Infrastructure as Code
