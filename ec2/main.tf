data "aws_ami" "ubuntu" {
  owners      = ["aws-marketplace"]
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.22.1-20-r22-linux-debian-11-x86_64-hvm-ebs-nami-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "template_file" "init" {
  template = file("${path.module}/user_data.tpl")

  vars = {
    ec2_private_key = var.ec2_private_key
  }
}

resource "aws_instance" "main" {
  count = var.instance_count

  ami                         = var.ami_id == null ? data.aws_ami.ubuntu.id : var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id[count.index]
  key_name                    = var.ec2_key_name
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  user_data                   = data.template_file.init.rendered

  tags = {
    Name = format("${var.name_tag}-%s", count.index + 1)
  }
}

resource "aws_security_group" "ec2" {
  vpc_id      = var.vpc_id
  description = var.name_tag
  name_prefix = var.name_tag
  lifecycle {
    create_before_destroy = true
  }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      protocol    = ingress.value.protocol
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_block
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name_tag
  }
}