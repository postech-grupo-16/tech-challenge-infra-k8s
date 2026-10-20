# O bucket abaixo (tech-challenge-soat16-grupo15) e criado pelo modulo
# ./backend (ver state-bucket.tf) - ou seja, este state raiz gerencia o
# proprio bucket que o guarda. Isso exige um bootstrap manual na primeira
# vez, porque o backend "s3" so inicializa se o bucket ja existir:
#
#   1. Comente o bloco `backend "s3" { ... }` abaixo.
#   2. terraform init && terraform apply
#      (roda com state local; cria o bucket, entre outros recursos)
#   3. Descomente o bloco `backend "s3" { ... }` de novo.
#   4. terraform init -migrate-state
#      (copia o state local, que ja inclui o bucket, para dentro dele mesmo)
#
# Depois disso, `terraform init`/`apply` normais (sem -migrate-state) fazem
# tudo, inclusive futuras mudancas no proprio bucket.
terraform {
  backend "s3" {
    bucket = "tech-challenge-infra-k8s-gabrielfsg"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}