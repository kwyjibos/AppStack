provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "AppStackSG" {
  description = "Allow to Appstack"
  name        = "AppStackSG"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "AppStackLB" {
  description = "LB SG for AppStack"
  name        = "AppStackLB"
}

resource "aws_elb" "AppStack-elb" {
  name     = "AppStack-elb"
  availability_zones   = "${var.availability_zones}"

  security_groups = ["${aws_security_group.AppStackLB.id}"]
  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:8080/"
    interval            = 30
  }
#  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300
}

resource "aws_launch_configuration" "AppStack" {
  name_prefix     = "AppStack"
  image_id        = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.AppStackSG.id}"]
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "AppStack" {
  name                 = "AppStack-asg"
  min_size             = "2"
  max_size             = "4"
  availability_zones   = "${var.availability_zones}"
#  vpc_zone_identifier  = ["${var.vpc_subnet}"]
  load_balancers       = ["${aws_elb.AppStack-elb.id}"]
  launch_configuration = "${aws_launch_configuration.AppStack.name}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "bootstrap-prod.sh"
}
