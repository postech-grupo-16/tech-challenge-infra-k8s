resource "kubectl_manifest" "storageclass_gp3" {
  # Ver comentario equivalente em k8s-metrics-server.tf sobre a dependencia
  # da access policy association.
  depends_on = [aws_eks_addon.ebs_csi_driver, aws_eks_access_policy_association.ae_association_voclabs]
  yaml_body  = file("${local.k8s_manifests}/storage-class.yaml")
}
