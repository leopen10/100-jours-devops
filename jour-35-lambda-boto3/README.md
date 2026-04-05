# Jour 35 - Optimisation des Couts Cloud avec AWS Lambda et Boto3

> Date : 5 avril 2026 | Statut : Completed avec preuve

## Projet - Supprimer les snapshots EBS inutilises

## Lambda deployee sur AWS
- Nom     : leonel-snapshot-cleanup
- ARN     : arn:aws:lambda:us-east-1:338183195778:function:leonel-snapshot-cleanup
- Runtime : Python 3.12
- Timeout : 300 secondes
- Role IAM: LambdaSnapshotRole

## Preuve execution
```
StatusCode : 200
Resultat   : {"total": 0, "supprimes": 0}
Conclusion : 0 snapshots orphelins - infrastructure propre !
```

## Prochain Jour
Jour 36 - AWS VPC et Networking
