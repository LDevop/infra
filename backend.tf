# terraform {
#   backend "local" {
#     path = "/home/ubuntu/tfstate/terraform.tfstate"
#   }
# }

terraform {
  backend "s3" {
    bucket = "tfstate-for-jenkins"
    key    = "jenkins/terraform.tfstate"
    region = "eu-central-1"
  }

}