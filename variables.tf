variable "region" {
  default     = "us-east-1"
  description = "this is the default region"
}

variable "env" {
  default = "demo"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "vpc_instance_tenancy" {
  default = "default"
}

variable "subnet_count" {
  default = 3
}

variable "subnet_bits" {
  default = 8
}

variable "vpc_name" {
  default = "vpc1"
}

variable "vpc_internet_gateway_name" {
  default = "IGWvpc1"
}

variable "vpc_public_subnet_name" {
  default = "PublicSubnetvpc1"
}

variable "vpc_public_routetable_name" {
  default = "PublicRouteTablevpc1"
}

variable "vpc_private_subnet_name" {
  default = "PrivateSubnetvpc1"
}

variable "vpc_private_routetable_name" {
  default = "PrivateRouteTablevpc1"
}
