variable "zone_id" {
  type = string
}

variable "record_creation_name" {
  type = string
}

variable "region" {
  default = "us-east-1"
}

variable "environment" {
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
  default = "IGvpc1"
}

variable "vpc_public_subnet_name" {
  default = "PublicSubnetvpc1"
}

variable "vpc_public_rt_name" {
  default = "PublicRTvpc1"
}

variable "vpc_private_subnet_name" {
  default = "PrivateSubnetvpc1"
}

variable "vpc_private_rt_name" {
  default = "PrivateRTvpc1"
}

# Instance creation config.

variable "ami_key_pair_name" {
  default = "ec2"
}

variable "ami_id" {
}

variable "instance_type" {
  default = "t2.micro"
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = 50
}

variable "app_port" {
  default = 3000
}

//RDS

variable "username" {
  default = "csye6225"
}
variable "password" {
}
variable "engine_version" {
  default = "8.0"
}

variable "identifier" {
  default = "csye6225"
}
variable "db_name" {
  default = "cloud2"
}

variable "db_port" {
  default = 3306
}

