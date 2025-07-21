resource "aws_ecr_repository" "app" {
  name                 = var.ecr_repository_name
  image_tag_mutability = var.ecr_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }

  encryption_configuration {
    encryption_type = var.ecr_encryption
  }

  tags = var.tags
}
