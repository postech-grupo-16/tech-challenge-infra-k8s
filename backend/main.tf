# Bucket S3 que guarda o terraform.tfstate deste mesmo módulo raiz
# (ver ../backend.tf, que configura o backend "s3" apontando pra ele).
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  # Evita "terraform destroy" acidental deste bucket enquanto ele guarda o
  # state de toda a infraestrutura (VPC/EKS/ECR/K8s/ele mesmo). Para derrubar
  # de verdade, remova esta linha antes do destroy.
  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

# Guarda o historico de versoes do state - permite recuperar uma versao
# anterior do tfstate se um apply corromper o arquivo atual.
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# O tfstate pode conter valores sensiveis em texto plano (ex.: outputs);
# criptografia em repouso por padrao.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket de state nunca deve ser publico.
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
