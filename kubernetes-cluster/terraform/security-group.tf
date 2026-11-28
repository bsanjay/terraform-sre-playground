resource "aws_security_group" "k8s" {
  name   = "k8s-lab-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["106.213.86.61/32"]
  }

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 2379
    to_port   = 2380
    protocol  = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 10250
    to_port   = 10250
    protocol  = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 30000
    to_port   = 32767
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
