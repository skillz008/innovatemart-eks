output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "developer_access_key_id" {
  description = "Developer IAM user access key ID"
  value       = aws_iam_access_key.developer.id
}

output "developer_secret_access_key" {
  description = "Developer IAM user secret access key"
  value       = aws_iam_access_key.developer.secret
  sensitive   = true
}

output "mysql_endpoint" {
  description = "MySQL RDS endpoint"
  value       = try(aws_db_instance.catalog_mysql.endpoint, "")
}

output "postgres_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = try(aws_db_instance.orders_postgres.endpoint, "")
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for carts"
  value       = try(aws_dynamodb_table.carts.name, "")
}
