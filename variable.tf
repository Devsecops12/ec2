
variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group" {
  type = set(string)
}

variable "subnet_id" {
  type = string
}

variable "subnet_id2" {
  type = string
}

variable "securitygroup443" {
  type = string
}

variable "tg_name" {
  type = string
}

variable "vpc" {
  type = string
}

variable "securitygroup80" {
  type = string
}

variable "certificate_arn" {
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
}

variable "role_name" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "hosted_Zone_Name" {
  type = string
}

variable "hosted_record-set" {
  type = string
}

variable "route53_record_ttl" {
  type = number
}

variable "fs_id" {
  type = string 
}

variable "volume_size" {
  type = number
}
