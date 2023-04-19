data "aws_db_subnet_group" "database" {
  name = "my-db-private-subnet-group"
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_db_instance" "mydb1" {
  identifier             = var.identifier
  allocated_storage      = var.all_stor
  engine                 = "postgres"
  engine_version         = "15.2"
  instance_class         = var.instance_class
  db_name                   = var.name
  username               = var.user
  password               = var.pass
  port                   = 5432
  parameter_group_name   = "default.postgres15"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rdssg.id]
  db_subnet_group_name   = data.aws_db_subnet_group.database.name

  tags = {
    Name = "example-db"
  }
}

resource "aws_security_group" "ec2sg" {
  name   = "EC2toRDS"
  vpc_id = data.aws_vpc.main.id
  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2toRDS"
  }
}

resource "aws_security_group" "rdssg" {
  name   = "RDStoEC2"
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "RDStoEC2"
  }
}

resource "aws_security_group_rule" "ec2tords" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2sg.id
  source_security_group_id = aws_security_group.rdssg.id
  depends_on = [
    aws_security_group.ec2sg,
    aws_security_group.rdssg
  ]
}

resource "aws_security_group_rule" "rdstoec2" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rdssg.id
  source_security_group_id = aws_security_group.ec2sg.id
  depends_on = [
    aws_security_group.ec2sg,
    aws_security_group.rdssg
  ]
}
