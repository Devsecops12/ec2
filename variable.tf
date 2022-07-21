
variable "ami" {
  type = string
}
variable "instance_count" {
  default = "2"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "tg_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "component" {
  type = string
}

variable "region" {
  type = string
  default = "us-east-2"
}




