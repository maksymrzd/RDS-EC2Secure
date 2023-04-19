variable "instance_class" {
    default = "db.t3.micro"
}

variable "user" {
  default = "postgres"
}

variable "pass" {
    default = "test123123"
}

variable "name" {
  default = "mydb1"
}

variable "identifier" {
  default = "mydb1"
}

variable "all_stor" {
  default = "20"
}

variable "vpc_id" {}