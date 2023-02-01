# RSA key of size 4096 bits
resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2" {
  key_name   = var.ec2_key_name
  public_key = tls_private_key.ec2.public_key_openssh
}

resource "local_sensitive_file" "tf-key" {
  content         = tls_private_key.ec2.private_key_pem
  filename        = "${var.ec2_key_name}.pem"
  file_permission = "0400"
}