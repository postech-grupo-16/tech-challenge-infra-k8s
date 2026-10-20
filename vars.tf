variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "tech-challenge"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    "Name" = "tech-challenge"
  }
}

variable "instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "state_bucket_name" {
  description = "Nome do bucket S3 do state remoto (precisa bater com backend.tf). Nomes de bucket S3 sao globais - troque antes do primeiro apply se este ja existir em outra conta."
  type        = string
  default     = "tech-challenge-infra-k8s-gabrielfsg"
}