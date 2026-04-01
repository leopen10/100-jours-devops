# Jour 23 — 70 Questions pour Réussir la Certification AWS 🎯

> ⏱️ Durée : 1h | 📅 Date : 1 avril 2026 | ✅ Statut : Complété

---

## 🎯 Objectif

Tester ses connaissances sur tous les services AWS couverts dans la formation DevOps pour préparer la certification AWS.

---

## 📋 AWS CodePipeline — Questions (1-15)

**Q1.** Qu'est-ce qu'AWS CodePipeline ?
> Un service qui automatise les étapes de Build, Test et Deploy dans un pipeline CI/CD.

**Q2.** Quels sont les composants principaux d'un pipeline ?
> Pipeline → Stage → Action → Artifact

**Q3.** Quelle est la différence entre CI et CD ?
> CI = intégrer et tester automatiquement. CD Delivery = déployer en pré-prod. CD Deployment = déployer en prod sans intervention.

**Q4.** Combien de pipelines sont gratuits avec AWS Free Tier ?
> 1 pipeline actif par mois gratuit.

**Q5.** Quels sont les types d'exécution d'un pipeline ?
> Started, In Progress, Succeeded, Failed, Stopped, Superseded.

**Q6.** Quelles sources sont supportées par CodePipeline ?
> GitHub, CodeCommit, S3, Bitbucket, GitLab.

**Q7.** Comment déclencher automatiquement un pipeline ?
> Via un webhook GitHub ou un événement S3.

**Q8.** Qu'est-ce qu'un Artifact dans CodePipeline ?
> Un fichier transmis entre les stages, stocké dans S3.

**Q9.** Peut-on avoir une approbation manuelle dans CodePipeline ?
> Oui, via une action d'approbation manuelle entre deux stages.

**Q10.** Quels outils de Build sont intégrables à CodePipeline ?
> AWS CodeBuild, Jenkins, CloudBees.

**Q11.** Quels outils de Deploy sont intégrables à CodePipeline ?
> CodeDeploy, S3, Elastic Beanstalk, ECS, CloudFormation.

**Q12.** Qu'est-ce qu'une transition dans CodePipeline ?
> Le lien entre deux stages, peut être activé ou désactivé.

**Q13.** Comment surveiller CodePipeline ?
> Via CloudWatch Events et CloudTrail.

**Q14.** Peut-on paralléliser des actions dans un stage ?
> Oui, en configurant plusieurs actions dans le même stage.

**Q15.** Quelle est la limite de stages dans un pipeline ?
> 10 stages maximum par pipeline.

---

## 🚀 AWS CodeDeploy — Questions (16-30)

**Q16.** Qu'est-ce qu'AWS CodeDeploy ?
> Un service qui automatise le déploiement d'applications sur EC2, Lambda, ECS et On-premises.

**Q17.** Quelles sont les 3 stratégies de déploiement principales ?
> In-place (Rolling), Blue/Green, Canary.

**Q18.** Qu'est-ce qu'un Deployment Group ?
> Un ensemble d'instances EC2 ciblées par un déploiement.

**Q19.** Quel fichier configure CodeDeploy ?
> appspec.yml

**Q20.** Quels sont les hooks disponibles dans appspec.yml ?
> ApplicationStop, BeforeInstall, AfterInstall, ApplicationStart, ValidateService.

**Q21.** Qu'est-ce que le déploiement Blue/Green ?
> Déployer sur de nouvelles instances (Green) puis basculer le trafic depuis les anciennes (Blue).

**Q22.** Quel est l'avantage principal du Blue/Green ?
> Zéro downtime + rollback instantané.

**Q23.** Qu'est-ce que le déploiement Canary ?
> Envoyer un petit pourcentage du trafic vers la nouvelle version avant de basculer complètement.

**Q24.** Quel agent doit être installé sur les instances EC2 ?
> L'agent CodeDeploy (codedeploy-agent).

**Q25.** Comment installer l'agent CodeDeploy sur Ubuntu ?
> wget l'installateur depuis S3 puis sudo ./install auto.

**Q26.** Quel IAM Role est nécessaire pour CodeDeploy ?
> CodeDeployServiceRole avec la policy AWSCodeDeployRole.

**Q27.** Quel IAM Role est nécessaire pour les instances EC2 ?
> EC2InstanceProfileCodeDeploy avec AmazonS3ReadOnlyAccess.

**Q28.** Qu'est-ce que le rollback dans CodeDeploy ?
> Redéploiement automatique de la dernière version stable en cas d'échec.

**Q29.** CodeDeploy est-il gratuit pour EC2 ?
> Oui, gratuit pour EC2 et On-premises.

**Q30.** Quelle configuration déploie un serveur à la fois ?
> CodeDeployDefault.OneAtATime

---

## 🏗️ AWS CodeBuild — Questions (31-45)

**Q31.** Qu'est-ce qu'AWS CodeBuild ?
> Un service de build entièrement managé qui compile le code, exécute les tests et produit des artefacts.

**Q32.** Quel fichier configure CodeBuild ?
> buildspec.yml

**Q33.** Quelles sont les phases de buildspec.yml ?
> install, pre_build, build, post_build.

**Q34.** Où sont stockés les artefacts CodeBuild ?
> Dans un bucket S3.

**Q35.** Quels runtimes sont supportés par CodeBuild ?
> Python, Node.js, Java, Go, Ruby, PHP, .NET, Docker.

**Q36.** Comment surveiller les builds CodeBuild ?
> Via CloudWatch Logs et CloudWatch Metrics.

**Q37.** Quelles métriques CodeBuild sont disponibles ?
> BuildDuration, SucceededBuilds, FailedBuilds, QueuedDuration.

**Q38.** CodeBuild peut-il builder des images Docker ?
> Oui, en activant le mode privileged dans l'environnement.

**Q39.** Quel est le format du buildspec.yml ?
> YAML, version 0.2.

**Q40.** Comment passer des variables d'environnement à CodeBuild ?
> Via la section environment_variables dans buildspec.yml ou dans la configuration du projet.

**Q41.** Qu'est-ce que le cache dans CodeBuild ?
> Stocker les dépendances entre les builds pour accélérer les builds suivants.

**Q42.** CodeBuild peut-il s'intégrer avec GitHub ?
> Oui, via OAuth ou via un webhook.

**Q43.** Quel est le timeout maximum d'un build CodeBuild ?
> 8 heures (480 minutes).

**Q44.** Comment sécuriser les secrets dans CodeBuild ?
> Via AWS Secrets Manager ou Parameter Store.

**Q45.** CodeBuild est-il serverless ?
> Oui, pas de serveurs à gérer, facturation à la minute.

---

## 🔐 IAM — Questions (46-55)

**Q46.** Qu'est-ce qu'IAM ?
> Identity and Access Management — gère les accès aux services AWS.

**Q47.** Quelle est la différence entre un utilisateur et un rôle IAM ?
> Utilisateur = identité permanente. Rôle = identité temporaire assumée par un service.

**Q48.** Qu'est-ce que le principe du moindre privilège ?
> Donner uniquement les permissions nécessaires pour effectuer une tâche.

**Q49.** Qu'est-ce qu'une policy IAM ?
> Un document JSON qui définit les permissions (Allow/Deny) sur des ressources.

**Q50.** Qu'est-ce que MFA ?
> Multi-Factor Authentication — couche de sécurité supplémentaire.

**Q51.** Quelle est la différence entre une policy gérée et une policy inline ?
> Gérée = réutilisable sur plusieurs entités. Inline = attachée à une seule entité.

**Q52.** Comment auditer les actions IAM ?
> Via AWS CloudTrail.

**Q53.** Qu'est-ce qu'un Instance Profile ?
> Un conteneur qui permet d'attacher un rôle IAM à une instance EC2.

**Q54.** Quand utiliser des Access Keys ?
> Pour l'accès programmatique (CLI, SDK). Jamais en production sur EC2 (utiliser les rôles).

**Q55.** Qu'est-ce que AWS STS ?
> Security Token Service — génère des credentials temporaires.

---

## 📊 CloudTrail & CloudWatch — Questions (56-65)

**Q56.** Qu'est-ce qu'AWS CloudTrail ?
> Un service d'audit qui enregistre toutes les actions API sur le compte AWS.

**Q57.** Combien de temps CloudTrail conserve les logs par défaut ?
> 90 jours. Pour plus longtemps, configurer un Trail vers S3.

**Q58.** Qu'est-ce qu'AWS CloudWatch ?
> Un service de monitoring qui collecte les métriques et logs des services AWS.

**Q59.** Qu'est-ce qu'une alarme CloudWatch ?
> Une notification déclenchée quand une métrique dépasse un seuil défini.

**Q60.** Quelles métriques EC2 sont disponibles par défaut ?
> CPUUtilization, NetworkIn, NetworkOut, DiskReadOps, StatusCheckFailed.

**Q61.** Comment envoyer des notifications CloudWatch ?
> Via SNS (Simple Notification Service) → Email, SMS, Lambda.

**Q62.** Qu'est-ce qu'un Log Group dans CloudWatch ?
> Un conteneur qui regroupe des Log Streams d'une même source.

**Q63.** Comment filtrer les logs CloudWatch ?
> Via des Metric Filters qui détectent des patterns dans les logs.

**Q64.** CloudTrail est-il activé par défaut ?
> Non, il faut le configurer. Les événements des 90 derniers jours sont visibles sans Trail.

**Q65.** Qu'est-ce qu'Amazon Athena en lien avec CloudTrail ?
> Permet d'analyser les logs CloudTrail stockés dans S3 via des requêtes SQL.

---

## ☁️ S3 & Divers — Questions (66-70)

**Q66.** Qu'est-ce qu'un bucket S3 ?
> Un conteneur de stockage d'objets avec un nom unique globalement dans AWS.

**Q67.** Comment héberger un site statique sur S3 ?
> Activer le Static Website Hosting sur le bucket et configurer une bucket policy publique.

**Q68.** Qu'est-ce que le versioning S3 ?
> Conserver plusieurs versions d'un même fichier pour pouvoir restaurer une version précédente.

**Q69.** Comment chiffrer les données dans S3 ?
> SSE-S3 (géré par AWS), SSE-KMS (clés KMS), SSE-C (clés client).

**Q70.** Quelle est la différence entre CodePipeline et GitHub Actions ?
> CodePipeline est natif AWS, intégré avec tous les services AWS. GitHub Actions est plus flexible, gratuit pour les repos publics, et fonctionne sans compte AWS complet.

---

## ✅ Notre Score

```
Services AWS maîtrisés :
  ✅ EC2           → Instance Ubuntu en production
  ✅ S3            → Site statique déployé automatiquement
  ✅ IAM           → Rôles et policies configurés
  ✅ CodeDeploy    → Agent installé et actif
  ✅ CloudTrail    → Audit des actions AWS
  ✅ CloudWatch    → Monitoring et métriques
  ✅ GitHub Actions → Équivalent CodeBuild + CodePipeline

Pipelines réels :
  ✅ Jour 12 : Build Flask → Artefact (20s)
  ✅ Jour 13 : Deploy S3 automatique (14s)
  ✅ Jour 22 : Deploy Django EC2 (23s)
```

---

## ➡️ Prochain Jour

[Jour 24 — Introduction à Docker](../jour-24-docker-introduction/)
