# resource "aws_instance" "app_server" {
#   # count = var.subnet_count

#   ami                  = var.ami_id
#   instance_type        = var.instance_type
#   key_name             = var.ami_key_pair_name
#   security_groups      = ["${var.sec_id}"]
#   iam_instance_profile = var.ec2_profile_name

#   tags = {
#     Name = "EC2-${var.ami_id}"
#   }

#   root_block_device {
#     volume_size = var.volume_size
#     volume_type = var.volume_type
#   }

#   user_data = <<EOF
#     #!/bin/bash
#     cd /home/ec2-user/webapp
#     echo DBHOST="${var.host_name}" > .env
#     echo DBUSER="${var.username}" >> .env
#     echo DBPASS="${var.password}" >> .env
#     echo DATABASE="${var.db_name}" >> .env
#     echo PORT=${var.app_port} >> .env
#     echo DBPORT=${var.db_port} >> .env
#     echo BUCKETNAME=${var.s3_bucket} >> .env

#     sudo chown -R root:ec2-user /var/log
#     sudo chmod -R 770 -R /var/log

#     sudo systemctl daemon-reload
#     sudo systemctl start webapp.service
#     sudo systemctl enable webapp.service  

#     sudo ../../../opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
#       -a fetch-config \
#       -m ec2 \
#       -c file:packer/cloudwatch-config.json \
#       -s 


#   EOF

#   subnet_id = var.subnet_ids[0]
# }


resource "aws_launch_template" "app_server" {
  name = "asg_launch_config"
  depends_on = [
    var.sec_group_application
  ]
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ami_key_pair_name
  # iam_instance_profile = var.ec2_profile_name
  iam_instance_profile {
    name = var.ec2_profile_name
  }

  # vpc_security_group_ids = [aws_security_group.application.id]


  network_interfaces {
    associate_public_ip_address = true
    security_groups             = ["${var.sec_id}"]
  }
  tags = {
    Name = "EC2-${var.ami_id}"
  }
  # disable_api_termination = true

  # root_block_device {
  #   volume_size = var.volume_size
  #   volume_type = var.volume_type
  # }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted   = true
      kms_key_id  = aws_kms_key.webapp-kms-ec2.arn
    }
  }


  user_data = base64encode(data.template_file.userData.rendered)

  # subnet_id = var.subnet_ids[0]

}

resource "aws_autoscaling_group" "app_autoscaling_group" {
  name             = "csye6225-asg-1"
  default_cooldown = 60
  min_size         = 1
  max_size         = 3
  desired_capacity = 1
  # subnet_id = var.subnet_ids[0]
  # vpc_zone_identifier = [for subnet in aws_subnet.public-subnet : subnet.id]
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }
  health_check_type = "EC2"
  #  termination_policies = ["OldestInstance", "Default"]
  tag {
    key                 = "webapp"
    value               = "webappInstance"
    propagate_at_launch = true
  }
  target_group_arns = [var.aws_lb_target_group_arn]
}
resource "aws_autoscaling_policy" "scaleUpPolicy" {
  name                    = "Up policy"
  policy_type             = "SimpleScaling"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  autoscaling_group_name  = aws_autoscaling_group.app_autoscaling_group.name
  metric_aggregation_type = "Average"
}

resource "aws_autoscaling_policy" "scaleDownPolicy" {
  name                    = "Down policy"
  policy_type             = "SimpleScaling"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  autoscaling_group_name  = aws_autoscaling_group.app_autoscaling_group.name
  metric_aggregation_type = "Average"

}

resource "aws_cloudwatch_metric_alarm" "scaleUpAlarm" {
  alarm_name          = "ASG_Scale_Up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 4

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_autoscaling_group.name
  }

  alarm_description = "Scale up if CPU > 4% for 1 minute"
  alarm_actions     = [aws_autoscaling_policy.scaleUpPolicy.arn]
}

resource "aws_cloudwatch_metric_alarm" "scaleDownAlarm" {
  alarm_name          = "ASG_Scale_Down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 2

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_autoscaling_group.name
  }

  alarm_description = "Scale down if CPU < 2% for 2 minutes"
  alarm_actions     = [aws_autoscaling_policy.scaleDownPolicy.arn]
}

data "aws_route53_zone" "hosted_zone" {
  name         = var.record_creation_name
  private_zone = false
}

resource "aws_route53_record" "record_creation" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_creation_name
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = var.application_load_balancer_dns_name
    zone_id                = var.application_load_balancer_zone_id
  }
}
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "webapp-kms-ec2" {

  # alias_name = "webapp-kms-rds"

  description = " Encryption key"

  key_usage = "ENCRYPT_DECRYPT"

  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  deletion_window_in_days = 7

  policy = jsonencode({

    "Id" : "key-consolepolicy-3",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          ]
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          ]
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })

}
