variable "project_name" {
  description = "The name of the project"
  type        = string
}
variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string

}

variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "db_indetifier" {
  description = "Identifier for the database, used in resource names"
  type        = string
}
variable "db_username" {
  description = "The username for the database"
  type        = string
}


variable "allocated_storage" {
  description = "The amount of storage (in GB) for the database"
  type        = number

}

variable "db_instance_class" {
  description = "The instance class for the database"
  type        = string

}

variable "db_engine" {
  description = "The database engine"
  type        = string

}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string

}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_port" {
  description = "The port for the database"
  type        = number
  default     = 5432

}

variable "app_image" {
  description = "The Docker image for the application"
  type        = string
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type        = number

}

variable "memory" {
  description = "Memory (MB) for the ECS task"
  type        = number

}

variable "port_mapping_name" {
  description = "Name for the port mapping"
  type        = string

}

variable "port_mapping_port" {
  description = "Port for the port mapping"
  type        = number

}

variable "desired_count" {
  description = "Desired number of task instances"
  type        = number
}

variable "launch_type" {
  description = "Launch type for the ECS service"
  type        = string

}

variable "task_role_arn" {
  description = "ARN of the IAM role for the ECS task"
  type        = string

}

variable "load_balancer_type" {
  description = "Type of the load balancer (e.g., 'network', 'application')"
  type        = string

}

variable "lb_internal" {
  description = "Whether the load balancer is internal"
  type        = bool

}

variable "protocol" {
  description = "Protocol for the load balancer"
  type        = string

}

variable "target_type" {
  description = "Type of target for the load balancer (e.g., 'instance', 'ip')"
  type        = string
}

variable "lb_listener_port" {
  description = "Port for the load balancer listener"
  type        = number
}

variable "ecs_sg_name" {
  description = "Name for the ECS security group"
  type        = string
  default     = "ecs-service-sg"
}

variable "ecs_sg_description" {
  description = "Description for the ECS security group"
  type        = string
  default     = "Allow HTTP/HTTPS traffic from public"
}

variable "ecs_sg_ingress_ports" {
  description = "List of TCP ports to open on the ECS SG"
  type        = list(number)
  default     = [8080, 443]
}

variable "ecs_sg_ingress_cidr_blocks" {
  description = "CIDR blocks allowed into the ECS SG"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_sg_name" {
  description = "Name for the database security group"
  type        = string
  default     = "db-sg"
}

variable "db_sg_description" {
  description = "Description for the database security group"
  type        = string
  default     = "Allow Postgres access only from ECS tasks"
}

variable "db_sg_ingress_ports" {
  description = "List of TCP ports to open on the DB SG"
  type        = list(number)
  default     = [5432]
}

variable "environment" {
  description = "Environment tag for all resources"
  type        = string
  default     = "dev"
}

variable "azs" {
  description = "List of availability zones for the VPC"
  type        = list(string)
}

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository for the application"
  type        = string
}

variable "ecr_mutability" {
  description = "Image tag mutability for the ECR repository"
  type        = string
}

variable "ecr_scan_on_push" {
  description = "Whether to scan images on push to ECR"
  type        = bool
}

variable "ecr_encryption" {
  description = "Encryption type for the ECR repository"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)

}