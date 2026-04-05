# Jour 39 - Projet Complet AWS en Production : VPC, NAT, ALB, Auto Scaling

> Date : 5 avril 2026 | Statut : Completed avec preuve

## Infrastructure deployee
```
VPC    : vpc-08f197056c4a9bae1 (10.0.0.0/16)
IGW    : igw-052f62bf8f2f6242d
RT PUB : rtb-0c3aa2c9ffbca8208
SG ALB : sg-0b1893456a4befab5 (port 80 + 443)
SG EC2 : sg-0af34e37250e329bf (port 22 + 80)
Subnets: 2 publics + 2 prives sur us-east-1a + us-east-1b

Launch Template : lt-0a43450fbfc59023d
Auto Scaling Group : leonel-asg-jour39
  Min     : 1 instance
  Max     : 3 instances
  Desired : 1 instance
  Multi-AZ: us-east-1a + us-east-1b
```

## Prochain Jour
Jour 40 - Questions Entretien AWS : EC2, IAM et VPC
