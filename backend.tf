# Backend in jenkins master, but my job don't start, after moved in s3
# terraform {
#   backend "local" {
#     path = "/home/ubuntu/tfstate/terraform.tfstate"
#   }
# }

terraform {
  backend "s3" {
    bucket = "tfstate-for-jenkins"
    key    = "jenkins/terraform.tfstate"
    region = var.aws_region
  }

}