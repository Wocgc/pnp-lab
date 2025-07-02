aws_region = "ap-northeast-2"
vpc_cidr   = "10.0.0.0/16"
public_subnet_cidrs = [
  "10.0.0.0/24", # public_subnet_a
  "10.0.10.0/24" # public_subnet_c
]
private_subnet_cidrs = [
  "10.0.1.0/24", # private_subnet_a
  "10.0.11.0/24" # private_subnet_c
]
private_subnet_2_cidrs = [
  "10.0.2.0/24", # private_subnet_2a
  "10.0.12.0/24" # private_subnet_2c
]
private_rds_subnet_cidrs = [
  "10.0.3.0/24", # private_rds_a
  "10.0.13.0/24" # private_rds_c
]
availability_zones = [
  "ap-northeast-2a",
  "ap-northeast-2c"
]
mgmt_ami           = "ami-0662f4965dfc70aca"
mgmt_instance_type = "t3.small"

rds_identifier          = "cgc-pnp-rds"
rds_engine              = "mysql"
rds_engine_version      = "8.0.41"
rds_instance_class      = "db.t3.micro"
rds_allocated_storage   = 20
rds_username            = "pnp"
rds_password            = "pnp12345"
rds_multi_az            = true
rds_publicly_accessible = false
