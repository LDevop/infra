variable "aws_region" {
  default     = "eu-central-1"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

variable "az_count" {
  default     = "2"
  description = "number of availability zones in above region"
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_image" {
  default     = "ldevop/adminer:2" #"adminer:latest"
  description = "docker image to run in this ECS cluster"
}

variable "app_port" {
  default     = "8080"
  description = "portexposed on the docker image"
}

variable "alb_listener_port" {
  default     = "80"
  description = "port exposed for alb listener"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "cpu" {
  default     = "256"
  description = "instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "memory" {
  default     = "512"
  description = "instance memory to provision (in MiB) not MB"
}

variable "name" {
  default = "EC2-Cluster"
}

variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

variable "amis" {
  description = "Which AMI to spawn."
  default     = "ami-093cfc6e8a3d255f9"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "db_username" {
  default = ""
}

variable "db_password" {
  default = ""
}

variable "public_key" {
  default = ""
}