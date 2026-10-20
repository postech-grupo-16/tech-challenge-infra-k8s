# Cria o bucket S3 usado pelo backend "s3" acima (ver backend.tf) - modulo
# local em ./backend, faz parte deste mesmo state raiz (mesmo tfstate de
# VPC/EKS/ECR/K8s). Ver o comentario em backend.tf sobre a ordem de bootstrap
# na primeira vez que este projeto e aplicado.
module "state_bucket" {
  source = "./backend"

  bucket_name = var.state_bucket_name
  tags        = var.tags
}
