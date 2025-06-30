terraform {
  backend "s3" {
    bucket         = "cgclab-terraform-state"          # 네가 만든 S3 버킷 이름
    key            = "terraform_eks/terraform.tfstate" # 저장될 경로
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-locks" # Locking 테이블 
  }
}

