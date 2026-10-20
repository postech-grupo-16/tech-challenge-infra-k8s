# voclabs: role assumida pela sua sessão pessoal (AWS CLI/console da AWS Academy)
resource "aws_eks_access_entry" "access_entry_voclabs" {
  cluster_name      = aws_eks_cluster.cluster.name
  principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/voclabs"
  kubernetes_groups = ["group-user", "group-admin"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "ae_association_voclabs" {
  cluster_name  = aws_eks_cluster.cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/voclabs"

  access_scope {
    type = "cluster"
  }

  # Sem isso, o Terraform nao sabe que esta associacao depende da access
  # entry acima (as duas referenciam a mesma ARN como string crua, nao via
  # atributo do recurso, entao nao ha dependencia implicita) - podem rodar
  # em paralelo ou fora de ordem, causando 404 (ResourceNotFoundException)
  # quando a associacao tenta rodar antes da access entry existir de fato.
  depends_on = [aws_eks_access_entry.access_entry_voclabs]
}