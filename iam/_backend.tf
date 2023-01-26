data "terraform_remote_state" "repository" {
  backend = "local"

  config = {
    path = "${path.module}/../codecommit/terraform.tfstate"
  }
}