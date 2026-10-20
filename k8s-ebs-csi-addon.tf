# O node group roda com o LabRole (AWS Academy), entao o addon usa as
# credenciais do proprio node (via IMDS) em vez de IRSA/OIDC. Em um ambiente
# com IAM proprio, prefira uma role dedicada via service_account_role_arn
# com a policy gerenciada AmazonEBSCSIDriverPolicy.
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.node_group]
}
