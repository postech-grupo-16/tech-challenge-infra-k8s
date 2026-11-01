locals {
  # Manifests de add-ons de cluster (storage class, metrics-server) vivem neste
  # repositorio. Os manifests da aplicacao (Deployment, Service, etc.) foram
  # para o repositorio tech-challenge-app, aplicados pelo CI dele via kubectl.
  k8s_manifests = "${path.module}/manifests"

  # Em producao os nomes ficam exatamente como antes (sem sufixo), para nao
  # forcar a recriacao de nada; os demais ambientes ganham o sufixo
  # (ex.: eks-tech-challenge-homolog, /tech-challenge-homolog/vpc_id).
  name_prefix = var.environment == "production" ? var.project_name : "${var.project_name}-${var.environment}"
  ssm_prefix  = "/${local.name_prefix}"
}
