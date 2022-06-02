data "aws_vpc" "cluster-vpc" {
  id = aws_vpc.cluster-vpc.id
}
data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.cluster-vpc.id
}
resource "aws_db_subnet_group" "subnet_rds" {
  name       = "subnet_mariadb"
  subnet_ids = data.aws_subnet_ids.subnet_ids.ids
}

resource "aws_db_instance" "adminer_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.6.7"
  instance_class         = "db.t3.micro"
  name                   = "db_adminer"  
  identifier             = "adminer-mariadb"
  username               = "foo"
  password               = "foobarbaz"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.subnet_rds.name
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
}

