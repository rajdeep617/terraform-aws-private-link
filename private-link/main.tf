resource "aws_vpc_endpoint_service" "main" {
  acceptance_required        = var.acceptance_required
  network_load_balancer_arns = var.network_load_balancer_arns
  supported_ip_address_types  = var.supported_ip_address_types
  tags = {
    Name = var.name_tag
  }
}
resource "aws_vpc_endpoint" "service" {
  vpc_id       = var.vpc_id
  service_name = aws_vpc_endpoint_service.main.service_name
  security_group_ids = [aws_security_group.endpoint.id]
  vpc_endpoint_type = "Interface"
  subnet_ids      = var.subnet_ids
  tags = {
    Name = var.name_tag
  }
}
resource "aws_security_group" "endpoint" {
  vpc_id      = var.vpc_id
  description = var.name_tag
  name_prefix = var.name_tag
  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port = 80
    protocol  = "TCP"
    to_port   = 80
    cidr_blocks = [var.cidr_block]
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
