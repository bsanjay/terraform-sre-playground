data "aws_ami" "amazonlinux" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "master" {

  ami           = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  private_ip = "10.0.1.10"

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.k8s.id
  ]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "kubemaster01"
  }
}

resource "aws_instance" "workers" {

  count = 2

  ami           = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  private_ip = "10.0.1.${11 + count.index}"

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.k8s.id
  ]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = format("kubenode%02d", count.index + 1)
  }
}
