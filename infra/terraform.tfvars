# terraform.tfvars
project_name = "my-aws-project"
# VPC Configuration
vpc_name             = "ecs-vpc"
cidr_block           = "10.0.0.0/16"
azs                  = ["eu-west-1a", "eu-west-1b"]
public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.101.0/24", "10.0.102.0/24"]

# ECS Cluster Configuration
cluster_name      = "my-ecs-cluster"
launch_type       = "FARGATE"
port_mapping_name = "web"
port_mapping_port = 8080
desired_count     = 1
cpu               = 256
memory            = 512
app_image         = "743638857435.dkr.ecr.eu-west-1.amazonaws.com/ecs-app-repo:0.0.7"
task_role_arn     = "arn:aws:iam::123456789012:role/my-ecs-task-role"


# Database Configuration
db_engine              = "postgres"
db_engine_version      = "17"
db_instance_class      = "db.t4g.micro"
allocated_storage      = 20
db_indetifier         = "ecs-db"
db_name                = "mydatabase"
db_username            = "dbuser"

# Load Balancer Configuration
lb_internal        = false
load_balancer_type = "network"
protocol           = "TCP"
target_type        = "ip"
lb_listener_port   = 8080

# --- security groups ---
ecs_sg_name                = "ecs-service-sg"
ecs_sg_description         = "Allow HTTP traffic from NLB"
ecs_sg_ingress_ports       = [8080, 443]
ecs_sg_ingress_cidr_blocks = ["0.0.0.0/0"]

db_sg_name          = "db-sg"
db_sg_description   = "Allow Postgres access only from ECS tasks"
db_sg_ingress_ports = [5432]

environment = "dev"


# ECR
ecr_repository_name = "ecs-app-repo"
ecr_mutability      = "MUTABLE"
ecr_scan_on_push    = false
ecr_encryption      = "AES256"



tags = {
  "Project"     = "ECS Project",
  "Environment" = "Production",
  "CreatedBy"   = "Terraform"
}