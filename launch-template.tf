# Sem isso, containers/pods nao alcancam o IMDS (hop limit padrao = 1, so o
# host consegue). O ebs-csi-driver depende do IMDS pra pegar as credenciais
# do node (LabRole), ja que este projeto nao usa IRSA/OIDC.
resource "aws_launch_template" "node" {
  name_prefix = "lt-${var.project_name}-"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}
