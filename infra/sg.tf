resource "aws_security_group" "ecs_sg" {
  name        = "ecs-service-sg"
  description = "Allow HTTP(S) traffic only from specific IPs"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from trusted range"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [
      "75.2.60.0/24",
      "109.173.171.143/32",
    ]
  }

  ingress {
    description = "Allow HTTPS from trusted range"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "75.2.60.0/24",
      "109.173.171.143/32",
    ]
  }

    ingress {
    description = "Allow API GW VPC Link on 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = module.vpc.public_subnets_cidr_blocks
  }
  ingress {
    description = "Allow API GW VPC Link on 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = module.vpc.public_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow Postgres access only from ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow Postgres from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}
