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
- Parâmetros no SSM Parameter Store (`/tech-challenge/vpc_id`, `/tech-challenge/vpc_cidr`, `/tech-challenge/subnet_ids`, `/tech-challenge/eks_cluster_name`) — é assim que os repositórios [tech-challenge-infra-db](https://github.com/Gabrielfsg/tech-challenge-infra-db) e [tech-challenge-auth-lambda](https://github.com/Gabrielfsg/tech-challenge-auth-lambda) leem a rede desta VPC sem compartilhar o Terraform state (ver [`ssm-outputs.tf`](ssm-outputs.tf))

## Pré-requisitos

- Terraform ≥ 1.9
- AWS CLI configurado (AWS Academy: credenciais temporárias do Learner Lab)
- Este projeto roda sob a role `LabRole` do AWS Academy — não cria roles/policies IAM próprias.

## Primeira execução (bootstrap do bucket de state)

O bucket S3 do state **não é gerenciado pelo Terraform** — é criado uma vez via AWS CLI, fora do Terraform. Isso é proposital: o provider AWS sempre tenta ler a configuração de "object lock" do bucket como parte do ciclo de vida do recurso `aws_s3_bucket`, e o AWS Academy bloqueia essa chamada (`GetBucketObjectLockConfiguration`) via Service Control Policy, sem exceção possível — isso quebraria o `apply` mesmo quando a criação do bucket em si funciona. Ver detalhes em [`backend.tf`](backend.tf).

Antes do primeiro `terraform init`, troque `tech-challenge-infra-k8s-gabrielfsg` no comando abaixo (e em `backend.tf`) por um nome de bucket S3 ainda não usado globalmente — nomes de bucket S3 são únicos em toda a AWS:

```bash
aws s3api create-bucket --bucket tech-challenge-infra-k8s-gabrielfsg --region us-east-1
aws s3api put-bucket-versioning --bucket tech-challenge-infra-k8s-gabrielfsg \
  --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket tech-challenge-infra-k8s-gabrielfsg \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
aws s3api put-public-access-block --bucket tech-challenge-infra-k8s-gabrielfsg \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

Depois disso, `terraform init`/`apply` normais funcionam direto.

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
