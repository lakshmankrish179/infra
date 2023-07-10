provider "aws" {
    region = "ap-south-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_launch_configuration" "test" {
    image_id = "ami-08e5424edfe926b43"
    instance_type = "t2.micro" 
    security_groups = [aws_security_group.instance.id]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World !" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_security_group" "instance" {
    name = "web"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_autoscaling_group" "test" {
  launch_configuration = aws_launch_configuration.test.name
  vpc_zone_identifier = data.aws_subnets.default.ids
  min_size = 1
  max_size = 1

  tag {
    key = "Name"
    value = "web"
    propagate_at_launch = true
  }
}
   