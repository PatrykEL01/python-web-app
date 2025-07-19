terraform {
  backend "s3" {
    bucket         = "ecs-project-state-bucket-235"
    key            = "global/terraform.tfstate"
    encrypt        = true
    use_lockfile = true
    region = "eu-west-1"
  }
}