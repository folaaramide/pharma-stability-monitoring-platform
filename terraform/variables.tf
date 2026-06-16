variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_a_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_b_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "stability_table_name" {
  type    = string
  default = "stability-results"
}

variable "incident_table_name" {
  type    = string
  default = "incidents"
}

variable "sns_email" {
  type    = string
  default = "afolabiaramide@outlook.com"
}