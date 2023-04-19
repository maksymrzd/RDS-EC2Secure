data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_security_group" "selected" {
  filter {
    name = "group-name"
    values = ["EC2toRDS"]
  }
}

data "aws_db_instance" "database" {
  db_instance_identifier = "mydb1"
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.selected.id]
  key_name               = "aws_key"
  user_data              = <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install docker -y
  sudo systemctl start docker
  sudo docker pull maksymrzd/my-db-website:v5.0
  sudo docker run -d -p 80:80 -e DB_HOST=$(echo ${data.aws_db_instance.database.endpoint} | cut -d: -f1) -e DB_PORT=5432 -e DB_NAME=mydb1 -e DB_USER=postgres -e DB_PASS=test123123 maksymrzd/my-db-website:v5.0
  EOF

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("aws_key.pem")
  }

  tags = {
    Name = "webserver"
  }
}
