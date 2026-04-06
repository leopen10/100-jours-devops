# Jour 47 - Docker Bind Mount vs Volume

> Date : 6 avril 2026 | Statut : Completed avec preuve

## Tests effectues
```
VOLUME :
  docker volume create leonel-data
  docker run -v leonel-data:/app/data python:3.12-slim
  Resultat : LEONEL DEVOPS - Jour 47 - Donnees persistantes

BIND MOUNT :
  docker run -v $(pwd)/mon-dossier:/app/data python:3.12-slim
  Resultat : LEONEL - Bind Mount Jour 47 - Mon Apr 6 09:32:46 UTC 2026
```

## Prochain Jour
Jour 48 - Docker Networking : Bridge vs Host vs Overlay
