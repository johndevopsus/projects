resource "aws_placement_group" "aps_pb" {
  name     = "aps_pb"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "asg_pb" {  
  name                      = "asg_pb"
  availability_zones = ["us-east-1a", "us-east-1b"]
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2

  launch_template {
    id      = aws_launch_template.lt_pb.id
    version = "$Latest"
  }
  

  tag {
    key                 = "Name"
    value               = "asg_pb"
    propagate_at_launch = false
  }
}

# resource "aws_autoscaling_policy" "CPUPolicy" {
#   name = "ASG-Policy"
#   policy_type = "TargetTrackingScaling"
#   estimated_instance_warmup = 200
#   autoscaling_group_name = aws_autoscaling_group.MyASG.name

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }

#     target_value = 60.0
#   }
# }

resource "aws_launch_template" "lt_pb" {
  name_prefix   = "lt_pb"
  image_id      = "ami-0482730ee38e3f893"
  instance_type = "t2.micro"


}

resource "aws_launch_template" "lt_pb" {

  name_prefix = "lt_pb"
  image_id = "ami-0482730ee38e3f893"
  instance_type = "t2.micro"
  key_name = "mykey"

  vpc_security_group_ids = [ aws_security_group.ec2_sg.id ]
  user_data = filebase64("${path.module}/example.sh")


  lifecycle {
    create_before_destroy = true
  }
}