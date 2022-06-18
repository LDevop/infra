resource "aws_db_subnet_group" "subnet_rds" {
  name       = "subnet_mariadb"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_db_instance" "adminer_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.6.7"
  instance_class         = "db.t3.micro"
  db_name                = "db_adminer"
  identifier             = "adminer-mariadb"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.subnet_rds.name
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
}

