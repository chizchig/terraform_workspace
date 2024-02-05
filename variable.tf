variable "vpc_cidr_block" {
  type = string
}

variable "external_subnet_cidr_blocks" {
  type = list(string)
}

variable "internal_subnet_cidr_blocks" {
  type = list(string)
}


variable "region" {
  type = string
}