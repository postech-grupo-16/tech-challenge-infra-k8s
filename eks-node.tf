resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "nodeg-${local.name_prefix}"
  node_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  subnet_ids      = aws_subnet.subnet_public[*].id
  instance_types  = var.instance_types

  # disk_size nao pode ser setado aqui junto com launch_template (conflito de
  # atributos no provider) - o volume raiz fica com o default da AMI (20GiB).
  launch_template {
    id      = aws_launch_template.node.id
    version = aws_launch_template.node.latest_version
  }

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  update_config {
    max_unavailable = 1
  }
}