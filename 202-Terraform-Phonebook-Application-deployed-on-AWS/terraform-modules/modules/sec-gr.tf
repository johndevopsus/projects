resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP inbound traffic"

    ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
    Name = "alb_sg"
    }
    }


resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow HTTP, SSH, RDS inbound traffic"

    ingress {
    description      = "TLS from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    #cidr_blocks      = [aws_security_group.alb_sg.id]
    security_group_id = [aws_security_group.alb_sg.id]
    }

    ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
    description      = "TLS from RDS"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }


    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
    Name = "ec2_sg"
    }
    }


resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow HTTP, SSH, RDS inbound traffic"

    ingress {
    description       = "TLS from EC2"
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    #cidr_blocks       = [aws_security_group.ec2_sg.id]
    security_group_id = [aws_security_group.ec2_sg.id]
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
    Name = "rds_sg"
    }
    }

output "rds_sg_id" {
    value = "${aws_db_security_group.rds_sg.id}"
}