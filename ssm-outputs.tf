# Publica os outputs que os repositorios irmaos (tech-challenge-infra-db,
# tech-challenge-auth-lambda) precisam, sem acoplar os Terraform state files
# entre repositorios (ver ADR sobre composicao multi-repo via SSM).
resource "aws_ssm_parameter" "vpc_id" {
  name  = "${local.ssm_prefix}/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "vpc_cidr" {
  name  = "${local.ssm_prefix}/vpc_cidr"
  type  = "String"
  value = aws_vpc.main.cidr_block
}

resource "aws_ssm_parameter" "subnet_ids" {
  name  = "${local.ssm_prefix}/subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.subnet_public.*.id)
}

resource "aws_ssm_parameter" "eks_cluster_name" {
  name  = "${local.ssm_prefix}/eks_cluster_name"
  type  = "String"
  value = aws_eks_cluster.cluster.name
}

resource "aws_ssm_parameter" "ecr_repository_name" {
  name  = "${local.ssm_prefix}/ecr_repository_name"
  type  = "String"
  value = aws_ecr_repository.app.name
}
