terraform {
  backend "s3" {
    bucket = "cgc-test-terraform-state"
    key    = "eks/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

