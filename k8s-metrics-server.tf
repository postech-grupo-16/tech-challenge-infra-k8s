data "kubectl_file_documents" "metrics_server" {
  content = file("${local.k8s_manifests}/metrics-server.yaml")
}

resource "kubectl_manifest" "metrics_server" {
  for_each = data.kubectl_file_documents.metrics_server.manifests
  # Precisa que a role voclabs ja tenha a access policy associada no
  # cluster (ver access_entry.tf), senao o provider kubectl recebe 403
  # (forbidden) do RBAC do proprio Kubernetes.
  depends_on = [aws_eks_node_group.node_group, aws_eks_access_policy_association.ae_association_voclabs]
  yaml_body  = each.value
}
