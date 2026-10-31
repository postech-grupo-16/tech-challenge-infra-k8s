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

variable "environment" {
  description = "Ambiente (production ou homolog) - define o sufixo dos nomes e o prefixo SSM"
  type        = string
  default     = "production"
}

variable "node_desired_size" {
  description = "Quantidade desejada de nodes no node group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Quantidade minima de nodes no node group"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Quantidade maxima de nodes no node group"
  type        = number
  default     = 3
}
