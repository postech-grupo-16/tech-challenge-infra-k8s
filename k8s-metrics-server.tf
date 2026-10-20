data "kubectl_file_documents" "metrics_server" {
  content = file("${local.k8s_manifests}/metrics-server.yaml")
}

resource "kubectl_manifest" "metrics_server" {
  for_each   = data.kubectl_file_documents.metrics_server.manifests
  depends_on = [aws_eks_node_group.node_group]
  yaml_body  = each.value
}
