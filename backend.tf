terraform {
  backend "s3" {
    bucket  = "cgc-test-terraform-state"        # 네가 만든 S3 버킷 이름
    key     = "terraform_eks/terraform.tfstate" # 저장될 경로
    region  = "ap-northeast-2"
    encrypt = true
  }
}

