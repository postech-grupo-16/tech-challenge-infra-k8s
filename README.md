# Tech Challenge — Infra Kubernetes (EKS)

Terraform que provisiona a infraestrutura AWS "de plataforma" para o Tech Challenge: VPC, cluster EKS, node group e ECR. Não contém manifests da aplicação — esses vivem em [tech-challenge-app](https://github.com/Gabrielfsg/tech-challenge-app) e são aplicados pelo CI daquele repositório via `kubectl apply -k k8s/`.

Faz parte do conjunto de 4 repositórios da Fase 3 do Tech Challenge (16SOAT):

| Repositório | Responsabilidade |
|---|---|
| [tech-challenge-app](https://github.com/Gabrielfsg/tech-challenge-app) | API Spring Boot + manifests K8s da aplicação + CI/CD |
| **tech-challenge-infra-k8s** (este) | Terraform: VPC, cluster EKS, node group, ECR |
| [tech-challenge-infra-db](https://github.com/Gabrielfsg/tech-challenge-infra-db) | Terraform: banco de dados gerenciado (RDS PostgreSQL) |
| [tech-challenge-auth-lambda](https://github.com/Gabrielfsg/tech-challenge-auth-lambda) | Function Serverless de autenticação via CPF + API Gateway |

## O que provisiona

- VPC + 3 subnets públicas + Internet Gateway + route table
- Cluster EKS (`eks-tech-challenge`) usando a role `LabRole` do AWS Academy (sem IAM/IRSA próprio)
- Node group gerenciado (`t3.medium`, 2-3 nós)
- Repositório ECR (`tech-challenge-backend`) com lifecycle policy (mantém as 5 imagens mais recentes)
- Add-ons de cluster: EBS CSI driver, metrics-server, StorageClass `gp3` (manifests em [`manifests/`](manifests/))
- Bucket S3 próprio para o state remoto (bootstrap descrito em [`backend.tf`](backend.tf))

## Pré-requisitos

- Terraform ≥ 1.9
- AWS CLI configurado (AWS Academy: credenciais temporárias do Learner Lab)
- Este projeto roda sob a role `LabRole` do AWS Academy — não cria roles/policies IAM próprias.

## Primeira execução (bootstrap do state remoto)

O bucket S3 do state é criado pelo próprio Terraform deste repositório (ver comentário em [`backend.tf`](backend.tf)). Antes do primeiro apply, troque `state_bucket_name` em [`vars.tf`](vars.tf) (e o `bucket` em `backend.tf`) por um nome de bucket S3 ainda não usado globalmente — nomes de bucket S3 são únicos em toda a AWS.

```bash
# 1. Comente o bloco backend "s3" {...} em backend.tf
terraform init
terraform apply   # cria VPC/EKS/ECR + o próprio bucket de state

# 2. Descomente o bloco backend "s3" {...} em backend.tf
terraform init -migrate-state
```

## Uso normal

```bash
terraform init
terraform plan
terraform apply
```

Para apontar o `kubectl` local para o cluster recém-criado:

```bash
terraform output configure_kubectl   # imprime o comando aws eks update-kubeconfig
```

Para publicar a imagem da aplicação no ECR (feito automaticamente pelo CI do [tech-challenge-app](https://github.com/Gabrielfsg/tech-challenge-app)):

```bash
terraform output docker_build_and_push
```

## Derrubando a infraestrutura

```bash
terraform destroy
```

> ⚠️ O cluster EKS e os nodes geram cobrança contínua. Rode `terraform destroy` assim que terminar os testes.

## CI/CD

[`.github/workflows/terraform.yml`](.github/workflows/terraform.yml): `plan` em todo push/dispatch, `apply` automático em push na `main`, `destroy` manual via `workflow_dispatch`. Requer os secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` configurados no repositório (credenciais do AWS Academy Learner Lab, que expiram — precisam ser atualizadas periodicamente).

A branch `main` é protegida — merges só via Pull Request.

---

Desenvolvido como Tech Challenge — Pós-Graduação em Arquitetura de Software (FIAP/16SOAT).
