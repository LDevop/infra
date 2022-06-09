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

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "cpu" {
  default     = "1024"
  description = "instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "memory" {
  default     = "256"
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
  default     = "ami-093cfc6e8a3d255f9" #"ami-02cf6acbf74959916"
}

variable "instance_type" {
  default = "t2.micro"
}

# variable "db_username" {
# }

# variable "db_password" {
# }

# variable "public_key" {
# }