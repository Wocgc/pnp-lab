variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs (Web tier)"
}

variable "private_subnet_2_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs (App tier)"
}

variable "private_rds_subnet_cidrs" {
  type        = list(string)
  description = "Private RDS subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZs to be used"
}

variable "rds_identifier" {
  type    = string
  default = "cgc-pnp-rds"
}

variable "rds_engine" {
  type    = string
  default = "mysql"
}

variable "rds_engine_version" {
  type    = string
  default = "8.0.41"
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_username" {
  type    = string
  default = "pnp"
}

variable "rds_password" {
  type      = string
  sensitive = true
}

variable "rds_multi_az" {
  type    = bool
  default = true
}

variable "rds_publicly_accessible" {
  type    = bool
  default = false
}

variable "mgmt_ami" {
  type = string
  default = "ami-0662f4965dfc70aca"
}

variable "mgmt_instance_type" {
  type = string
  default = "t2.micro"
}
