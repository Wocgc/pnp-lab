resource "aws_db_subnet_group" "rds-snt-group" {
  name       = "rds-snt-group"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_c.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = var.rds_identifier
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.rds-snt-group.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  multi_az               = var.rds_multi_az
  publicly_accessible    = var.rds_publicly_accessible
  skip_final_snapshot    = true
}
