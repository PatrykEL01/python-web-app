resource "null_resource" "create_sm_secret" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
password=$(openssl rand -base64 32)
aws secretsmanager create-secret --name db_password --secret-string "$password" || aws secretsmanager put-secret-value --secret-id example --secret-string "$password"
EOT
  }
}

data "aws_secretsmanager_secret" "db_password" {
  name       = "db_password"
  depends_on = [null_resource.create_sm_secret]
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
  depends_on = [null_resource.create_sm_secret]
}

resource "aws_secretsmanager_secret" "db_connection_string" {
  name        = "database_connection_string"
  description = "Database connection string"

}

resource "aws_secretsmanager_secret_version" "db_connection_string" {
  secret_id     = aws_secretsmanager_secret.db_connection_string.id
  secret_string = module.db.db_instance_endpoint
}