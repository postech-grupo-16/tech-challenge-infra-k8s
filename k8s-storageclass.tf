resource "kubectl_manifest" "storageclass_gp3" {
  depends_on = [aws_eks_addon.ebs_csi_driver]
  yaml_body  = file("${local.k8s_manifests}/storage-class.yaml")
}
