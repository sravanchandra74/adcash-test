resource "aws_ecr_repository" "app_repo" {
  name                 = "gandalf-colombo-app"
  image_tag_mutability = "MUTABLE" # Or IMMUTABLE for production
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "gandalf-colombo"
    Environment = var.environment
    Project     = var.project_name
  }
}