# Jour 48 - Docker Networking : Bridge vs Host vs Overlay

> Date : 6 avril 2026 | Statut : Completed avec preuve

## Reseaux Docker par defaut
```
bridge  → Reseau par defaut entre conteneurs
host    → Partage le reseau de la machine hote
none    → Aucun reseau (isolation totale)
```

## Reseau custom cree et teste
```
docker network create leonel-network

conteneur-1 → 172.18.0.2/16
conteneur-2 → 172.18.0.3/16

Les 2 conteneurs communiquent sur le meme reseau bridge
```

## Prochain Jour
Jour 49 - Questions Entretien Docker
