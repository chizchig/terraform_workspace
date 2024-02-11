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

# variable "aws_access_key_id" {
#   type = string
# }

# variable "aws_secret_access_key" {
#   type = string
# }

# variable "vpc_id" {
#   type = string
# }

