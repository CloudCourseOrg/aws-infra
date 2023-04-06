resource "aws_security_group" "loadbalancer_sg" {
  name_prefix = "lb_sg"
  description = "Allow access to application"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "sec_group_id_lb" {
  value = aws_security_group.loadbalancer_sg.id
}
# /*
# In this example, we're creating two security groups: web_app_sg for the web application and lb_sg for the load balancer. The web_app_sg allows incoming traffic on port 80 from the lb_sg security group, and the lb_sg allows incoming traffic on port 80 from anywhere (0.0.0.0/0) and outgoing traffic to the web_app_sg security group.

# Note that you'll need to replace the aws_security_group resource type and attribute names with the appropriate values for your cloud provider, and adjust the port numbers and CIDR blocks as needed for your application.
# */
