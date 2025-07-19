module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  engine         = var.db_engine
  engine_version = var.db_engine_version

  instance_class    = var.db_instance_class
  allocated_storage = var.allocated_storage
  db_name           = var.db_name
  username          = var.db_username
  password          = data.aws_secretsmanager_secret_version.db_password.secret_string
  port              = var.db_port

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  subnet_ids             = module.vpc.private_subnets
  publicly_accessible    = false
  multi_az               = false

  identifier                  = "${var.project_name}-db"
  skip_final_snapshot         = true
  create_db_option_group      = false
  create_db_parameter_group   = false
  create_db_subnet_group      = true
  create_monitoring_role      = true
  manage_master_user_password = false


  depends_on = [null_resource.create_sm_secret]


}
