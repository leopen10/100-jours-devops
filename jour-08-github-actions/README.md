# Jour 08 — Git & GitHub Actions : Pipeline CI/CD 🚀

> ⏱️ Durée : ~1h17 | 📅 Date : 31 mars 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Maîtriser Git et GitHub Actions pour construire un **pipeline CI/CD robuste** basé sur une application Flask :
- Gestion professionnelle Git : commits, branches, tags, releases
- Pipeline CI/CD : tests automatisés, audit sécurité, notifications
- Bonnes pratiques DevOps : secrets, versionnement sémantique

---

## 📦 Structure du Projet

```
flaskapp/
├── app.py                    # API Flask
├── requirements.txt          # Dépendances
├── tests/
│   └── test_app.py          # Tests unitaires pytest
├── .gitignore
└── .github/
    └── workflows/
        └── ci.yml           # Pipeline CI/CD
```

---

## 📄 app.py — API Flask

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/hello", methods=["GET"])
def hello():
    return jsonify({"message": "Hello from Flask!"})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
```

---

## 📄 tests/test_app.py — Tests unitaires

```python
from app import app

def test_hello():
    client = app.test_client()
    response = client.get("/hello")
    assert response.status_code == 200
    assert response.json == {"message": "Hello from Flask!"}
```

---

## 🌿 Stratégie de Branches DevOps

| Branche | Usage |
|---------|-------|
| `main` | Code stable, prêt pour la production |
| `develop` | Intégration continue |
| `feature/xyz` | Nouvelles fonctionnalités |
| `test/xyz` | Tests expérimentaux |
| `hotfix/xyz` | Correctifs urgents production |

### Workflow
```bash
git checkout -b feature/nouvelle-route
# Développer...
git add . && git commit -m "feat: add new route"
git checkout main
git merge feature/nouvelle-route
git branch -d feature/nouvelle-route
```

---

## ⚙️ Pipeline CI/CD — .github/workflows/ci.yml

```yaml
name: Flask CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: 🧾 Cloner le dépôt
        uses: actions/checkout@v4

      - name: 🐍 Configurer Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.10'

      - name: 📦 Installer les dépendances
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: ✅ Tests unitaires
        run: pytest tests/ --verbose

      - name: 🛡️ Audit de sécurité
        run: |
          pip install pip-audit
          pip-audit

  notify:
    needs: build
    if: failure()
    runs-on: ubuntu-latest
    steps:
      - name: 🚨 Alerte email échec
        uses: dawidd6/action-send-mail@v3
        with:
          server_address: smtp.gmail.com
          server_port: 465
          username: ${{ secrets.MAIL_USER }}
          password: ${{ secrets.MAIL_PASS }}
          to: leonelpengou10@gmail.com
          subject: "🚨 Échec CI - FlaskApp"
          body: |
            ❌ Échec du pipeline !
            Repo : ${{ github.repository }}
            Branche : ${{ github.ref }}
            Commit : ${{ github.sha }}

  release:
    if: startsWith(github.ref, 'refs/tags/v')
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v4
      - name: 📦 Créer Release GitHub
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{ github.ref_name }}
          name: Release ${{ github.ref_name }}
          body: |
            Release stable de FlaskApp
            - Tests unitaires validés ✅
            - Audit sécurité effectué 🛡️
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## 🏷️ Tags et Releases

```bash
# Créer un tag sémantique
git tag -a v1.0.0 -m "Release stable v1.0.0"
git push origin v1.0.0

# Lister les tags
git tag -l

# Versionnement sémantique : MAJEUR.MINEUR.CORRECTIF
# v1.0.0 → v1.0.1 (correctif)
# v1.0.0 → v1.1.0 (nouvelle fonctionnalité)
# v1.0.0 → v2.0.0 (changement majeur)
```

---

## 🔐 Gestion des Secrets GitHub

```
GitHub → Settings → Secrets and variables → Actions
→ New repository secret

MAIL_USER : leonelpengou10@gmail.com
MAIL_PASS : [mot de passe application Gmail]
```

**Règle d'or :** Jamais de secrets dans le code → toujours dans GitHub Secrets !

---

## ✅ Bonnes Pratiques

- **Commits** : `feat:`, `fix:`, `test:`, `chore:`, `docs:`
- **Branches** : dédiées par fonctionnalité
- **Tests** : automatisés à chaque push
- **Sécurité** : audit des dépendances
- **Secrets** : GitHub Secrets, jamais en clair
- **Versionnement** : tags sémantiques

---

## 🏋️ Projet Pratique
---

## ✅ Preuve d'exécution sur AWS EC2

**Serveur :** Ubuntu 24.04 — AWS EC2 t3.micro — us-east-1  
**Environnement :** Python 3.12 + venv-devops  
**Date :** 31 mars 2026

### Routes Flask testées
```
GET /hello  → {"message": "Hello from Flask!"}
GET /health → {"status": "healthy", "service": "flaskapp", "version": "1.0.0"}
GET /info   → {"app": "DevOps FlaskApp", "author": "Leonel-Magloire PENGOU MBA"}
```

### Résultats pytest
```
platform linux -- Python 3.12.3, pytest-9.0.2
collected 3 items

test_app.py::test_hello   PASSED  [ 33%]
test_app.py::test_health  PASSED  [ 66%]
test_app.py::test_info    PASSED  [100%]

3 passed in 0.12s ✅
```

**Concepts démontrés :**
- API REST Flask avec 3 routes
- Tests unitaires avec pytest (100% passing)
- Virtual environment Python (venv)
- Pipeline CI/CD GitHub Actions (ci.yml)
- Gestion des secrets GitHub
- Tags sémantiques et releases automatiques

Voir [`flaskapp/`](./flaskapp/) — Application Flask complète avec pipeline CI/CD.

---

## ➡️ Prochain Jour

[Jour 09 — Docker Introduction](../jour-09-docker/)
