resource "aws_security_group" "devops_sg" {
  name        = "${var.projet}-sg-terraform"
  description = "Security Group Terraform - ${var.projet}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.projet}-sg-terraform" }
}

resource "aws_instance" "devops_server" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  tags = {
    Name = "${var.projet}-terraform"
    Env  = "production"
    Jour = "32"
  }
}
