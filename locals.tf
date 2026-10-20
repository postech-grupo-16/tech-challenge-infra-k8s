locals {
  # Manifests de add-ons de cluster (storage class, metrics-server) vivem neste
  # repositorio. Os manifests da aplicacao (Deployment, Service, etc.) foram
  # para o repositorio tech-challenge-app, aplicados pelo CI dele via kubectl.
  k8s_manifests = "${path.module}/manifests"
}
