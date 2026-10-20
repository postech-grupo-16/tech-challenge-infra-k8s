output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_cidr" {
  value = aws_subnet.subnet_public.*.cidr_block
}

output "subnet_id" {
  value = aws_subnet.subnet_public.*.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "configure_kubectl" {
  description = "Comando para configurar o kubectl local apontando para o cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.cluster.name}"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "docker_build_and_push" {
  description = "Comandos para publicar a imagem da aplicacao no ECR"
  value       = <<-EOT
    aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.app.repository_url}
    docker build -t ${aws_ecr_repository.app.repository_url}:latest .
    docker push ${aws_ecr_repository.app.repository_url}:latest
  EOT
}