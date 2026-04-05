# Jour 37 - Pratique AWS VPC avec 4 Subnets + EC2 et Securite

> Date : 5 avril 2026 | Statut : Completed avec preuve

## Infrastructure deployee
```
VPC     : vpc-0e5cb020733c81e12 (10.0.0.0/16)
Subnets : 2 publics + 2 prives sur us-east-1a et us-east-1b
IGW     : attache au VPC
RT PUB  : route 0.0.0.0/0 vers IGW
SG      : sg-03cb66da40a73adab (port 22 + 80)

EC2 lancee dans le VPC custom :
  ID     : i-00c6c907a492cc5c1
  IP pub : 44.204.141.143
  Type   : t3.micro Ubuntu 24.04
  Subnet : Public us-east-1a
```

## Prochain Jour
Jour 38 - DNS et AWS Route 53
