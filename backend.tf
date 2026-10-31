# O bucket abaixo NAO e gerenciado pelo Terraform (nao existe mais um
# recurso aws_s3_bucket para ele neste projeto). Isso e proposital: o
# provider AWS sempre tenta ler a configuracao de "object lock" do bucket
# como parte do ciclo de vida do recurso aws_s3_bucket, e o AWS Academy
# bloqueia essa chamada (GetBucketObjectLockConfiguration) via Service
# Control Policy, sem excecao possivel - isso quebra o apply mesmo quando a
# criacao do bucket em si funciona.
#
# Bootstrap (uma vez só, via AWS CLI, antes do primeiro `terraform init`):
#
#   aws s3api create-bucket --bucket <nome-do-bucket> --region us-east-1
#   aws s3api put-bucket-versioning --bucket <nome-do-bucket> \
#     --versioning-configuration Status=Enabled
#   aws s3api put-bucket-encryption --bucket <nome-do-bucket> \
#     --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
#   aws s3api put-public-access-block --bucket <nome-do-bucket> \
#     --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
#
# Depois disso, `terraform init`/`apply` normais funcionam direto - sem a
# dança de comentar/descomentar backend que versoes anteriores deste
# arquivo exigiam.
#
# A key do state depende do ambiente e vem de environments/<env>.s3.tfbackend:
#
#   terraform init -backend-config=environments/production.s3.tfbackend
#   terraform init -backend-config=environments/homolog.s3.tfbackend
terraform {
  backend "s3" {
    bucket = "tech-challenge-gp15"
    region = "us-east-1"
  }
}
