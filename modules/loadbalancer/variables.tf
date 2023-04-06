variable "project_name" {
  default = "awsLB"
}
# variable "alb_security_group_id" {
#     type = number
# }
variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(any)
}

variable "app_port" {
  type = number
  default = 3000
}
