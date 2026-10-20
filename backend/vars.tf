variable "bucket_name" {
  description = "Nome do bucket S3 (precisa bater com o backend \"s3\" em ../backend.tf)"
  type        = string
}

variable "tags" {
  description = "Tags aplicadas ao bucket de state"
  type        = map(string)
}
