resource "aws_eks_cluster" "cluster" {
  name = "eks-${var.project_name}"

  access_config {
    authentication_mode = "API"
  }

  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  version  = "1.36"

  vpc_config {
    subnet_ids         = aws_subnet.subnet_public[*].id
    security_group_ids = [aws_security_group.security_group.id]
  }
}