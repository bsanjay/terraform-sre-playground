data "aws_ami" "terra-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "terra-public-instance-1" {
  ami                    = data.aws_ami.terra-ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.terra-public-subnet-1.id
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.terra-sg.id]
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }
  user_data                   = file("${path.module}/nginx.sh")
  user_data_replace_on_change = true

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/aws-key")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "prometheus-install.sh"
    destination = "/tmp/prometheus-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/prometheus-install.sh",
      "sudo bash -x /tmp/prometheus-install.sh"
    ]
  }
  tags = {
    Name = "terra-public-instance-1"
  }
}

resource "aws_instance" "terra-private-instance-1" {
  ami                    = data.aws_ami.terra-ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.terra-private-subnet-1.id
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.terra-sg.id]
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }

  tags = {
    Name = "terra-private-instance-1"
  }
}
