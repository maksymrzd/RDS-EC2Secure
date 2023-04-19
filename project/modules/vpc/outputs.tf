output "vpc_id" {
  value = aws_vpc.mainvpc.id
}

output "vpc_cidr" {
  value = aws_vpc.mainvpc.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.publics[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.privates[*].id
}

output "aws_db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.name
}